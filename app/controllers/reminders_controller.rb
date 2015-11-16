# encoding: utf-8

class RemindersController < ApplicationController 
  
  def show
    @group = Group.find params[:id]
    
    puts "ParaMS: #{params.inspect}"
    # @state = params[:state] || 2
    # @start_date = @group.created_at
    # @stop_date = DateTime.now
    # @journal_entries = JournalEntry.for_parent_with_state(@group, @state).between(@start_date, @stop_date).
    #   paginate(:all, :page => params[:page], :per_page => 40, :order => 'created_at desc')
    # @stop_date = @journal_entries.any? && @journal_entries.last.created_at || DateTime.now
    # puts "#{params[:state]}"
    set_params_and_find(params)
    
    puts "params:: #{params.inspect}"
    @answer_state = params[:state].join('-') ||  "2-4"
    @surveys = Survey.all.to_a.inject({}) { |h,elem| h[elem.id] = elem; h }.invert
    @states = {'Alle' => 0, 'Ubesvaret' => 2, 'Besvaret' => "5,6", 'Kladde' => 4} #JournalEntry.states
    respond_to do |format|
      format.html
      format.js { render :partial => 'entries' }
    end
  end

  # def filter
  #   @group = Group.find params[:id]
  #   set_params_and_find(params)

  #   respond_to do |format|
  #     format.html
  #     format.js { puts "JS!!!"; render :partial => 'entries'}
  #   end
  # end
  
  # update reminder status for multiple journal_entries
  def update
    group = Group.find params[:id]
    puts "params: #{params.inspect}"

    reminder_status = params[:reminder_status]
    journal_entries = JournalEntry.find(params[:journal_entries])
    journal_entries.each do |entry| 
      entry.set_reminder_state(reminder_status)
      puts entry.reminder_status
      entry.save
    end
    redirect_to answer_status_path(group) #, [2,4])
  end

  def generate_file
    @group = Group.find(params[:id])
    selected_state = params[:state].split(",").map &:to_i
    selected_state = [2,3,4,5,6] if selected_state == "0"

    @state = selected_state.to_a
    @is_answered = @state == [5,6]
    @start_date = @group.created_at
    @stop_date = DateTime.now

    status = JournalEntry.status_name[selected_state]
    timestamp = Time.now.strftime('%Y%m%d%H%M')
    filename = "journalstatus_#{@group.group_name_abbr.underscore}-#{status}-#{timestamp}.xls" 

    # use_filter = !params[:active].nil?
    filter = params[:active]

    done_file = true
    @journal_entries = JournalEntry.for_parent_with_state(@group, @state).
      between(@start_date, @stop_date).active_state(filter).all(:order => 'journal_entries.created_at desc', :include => [:journal, :login_user]) unless @state.empty?
    export_csv_helper = ExportCsvHelper.new
    rows = export_csv_helper.get_entries_status(@journal_entries)
    done_file = rows.any?
    # puts "rows: #{rows.inspect}"
    @export_file = ExportFile.export_xls_file rows, filename, "application/vnd.ms-excel" #if rows.first
    puts "export_file: #{@export_file.inspect}"

    respond_to do |wants|
      wants.js {
        render
      }
    end    
  end


  protected 
  
  def export_csv(csv, filename, type = "application/vnd.ms-excel; charset=utf-8")
    bom = "\377\376"
    content = csv # Iconv.conv('utf-16le', 'utf8', csv)
    send_data content, :filename => filename, :type => type, :disposition => 'attachment'
  end

  def set_params_and_find(params)
    # puts "#{params[:state].inspect}"
    params[:state] ||= "2-4"
    states = params[:state].split("-")
    # puts "states: #{states.inspect}"
    params[:state] = states.map &:to_i
    params[:selected_state] = params[:state]
    # puts "#{params[:state].inspect}"
    params[:state] = params[:journal_entry][:state] if params[:journal_entry] && params[:journal_entry][:state] 
    puts "selected_state: #{params[:selected_state].inspect} state: #{params[:state].inspect}"
    @state = params[:selected_state] if params[:selected_state]
    @state = states # params[:state].to_s.split(',') unless params[:state].blank?
    @state = [] if @state.nil?    [2,3] if @state.nil?
    @answer_state = @state.join(",")
    @state = JournalEntry.states.values if params[:state] == "0"
    @start_date = @group.created_at.beginning_of_day
    @stop_date = DateTime.now.end_of_day
    puts "@state: #{@state}"
    @journal_entries_count = JournalEntry.for_parent_with_state(@group, @state).
      between(@start_date, @stop_date).count
    @journal_entries = JournalEntry.for_parent_with_state(@group, @state).
      between(@start_date, @stop_date).all(:order => 'journals.title asc', :include => :journal) unless @state.empty?
    @stop_date = @journal_entries.any? && @journal_entries.last.created_at || DateTime.now
  end

  def check_access
    return !!current_user
  end
end