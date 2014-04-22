class ExportFile < ActiveRecord::Base 

  has_one :task
  
  attr_accessible :filename, :content_type

  default_scope order('created_at DESC')

  def self.storage_path
    "#{Rails.root}/files"
  end

  # run write_file after save to db
  after_save :write_file
  
  # run delete_file method after removal from db
  after_destroy :delete_file
  
  # setter for form file field "cover" 
  # grabs the data and sets it to an instance variable.
  # we need this so the model is in db before file save,
  # so we can use the model id as filename.
  def data=(file_data)
    @file_data = file_data
  end
  
  # write the @file_data data content to disk,
  # saves the file with the filename of the model id
  # together with the file original extension
  def write_file
    if @file_data
      File.open("#{ExportFile.storage_path}/#{filename}", "w") { |file| file.write(@file_data) }
    end
  end
  
  # deletes the file(s) by removing the whole dir
  def delete_file
    FileUtils.rm_rf("#{ExportFile.storage_path}/#{filename}")
  end
  
  # just gets the extension of uploaded file
  def extension
    @file_data.original_filename.split(".").last
  end
  
  def self.sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name).strip
    # replace spaces with underscore
    just_filename.gsub!(/s/,'_')
    # replace all none alphanumeric, underscore or perioids with underscore
    just_filename.gsub(/[^\w\.\_]/,'_') 
  end

  def self.export_xls_file(csv_table, filename, content_type = 'text/csv; charset=utf-8; header=present')
    return unless csv_table
    # table = csv_table.inject([]) do |a, t|
    #   a << t.values
    #   a
    # end
    # puts "table: #{table.inspect}"
    ExcelConverter.new.write_file(csv_table, "public/files/#{filename}")
    # puts "CONTENT: #{content.inspect}"

    export_file = ExportFile.find_by_filename(filename) ||
      ExportFile.create(
        :filename => filename,
        :content_type => content_type)
  end
  
end