class Letter < ActiveRecord::Base
  audited
  belongs_to :group
  belongs_to :center

  validates_associated :group, :allow_blank => true
  validates_presence_of :letter
  validates_presence_of :name
  # validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up], :message => "Der findes allerede et brev for denne skematype og opfølning for gruppen. Har du valgt den rigtige gruppe?"

  # attr_accessible :name, :surveytype, :group_id, :follow_up, :letter
  attr_accessible :name, :group_id, :letter

  scope :in_center, -> (center) { where(:center_id => (center.is_a?(Center) ? center.id : center)) }
  # scope :in_center, -> { where('center_id = ?', ), lambda { |group| { :conditions => ['center_id = ?', group.is_a?(Center) ? group.id : group] } }
  scope :with_cond, -> (cond) { where(cond[:conditions]) }


  def get_follow_up
    # self.follow_up ||= 0
    return "Alle" unless self.follow_up  
    FollowUp.get[self.follow_up].first
  end

  def insert_text_variables(variables)
    self.letter.gsub!('{{login}}', variables[:login]) if variables.key? :login
    self.letter.gsub!('{{brugernavn}}', variables[:login]) if variables.key? :login
    self.letter.gsub!('{{password}}', variables[:password]) if variables.key? :password
    self.letter.gsub!('{{kodeord}}', variables[:password]) if variables.key? :password
    self.letter.gsub!('{{name}}', variables[:title]) if variables.key? :title
    self.letter.gsub!('{{navn}}', variables[:title]) if variables.key? :title
    self.letter.gsub!('{{firstname}}', variables[:firstname]) if variables.key? :firstname
    self.letter.gsub!('{{fornavn}}', variables[:firstname]) if variables.key? :firstname
    self.letter.gsub!('{{mor_navn}}', variables[:parent_name]) if variables.key? :parent_name
    self.letter.gsub!('{{projektnr}}', variables[:alt_id]) if variables.key? :alt_id
  end
  
  def to_mail_merge
    self.letter.gsub!('{{login}}', '{ MERGEFIELD login }')
    self.letter.gsub!('{{brugernavn}}', '{ MERGEFIELD brugernavn }')
    self.letter.gsub!('{{password}}', '{ MERGEFIELD password }')
    self.letter.gsub!('{{kodeord}}', '{ MERGEFIELD kodeord }')
    self.letter.gsub!('{{name}}', '{ MERGEFIELD name }')
    self.letter.gsub!('{{navn}}', '{ MERGEFIELD navn }')
    self.letter.gsub!('{{firstname}}', '{ MERGEFIELD firstname }')
    self.letter.gsub!('{{fornavn}}', '{ MERGEFIELD fornavn }')
    self.letter.gsub!('{{mor_navn}}', '{ MERGEFIELD mor_navn }')
    self.letter.gsub!('{{projektnr}}', '{ MERGEFIELD projektnr }')
  end

  def self.find_default(surveytype)
    Letter.where(['group_id IS NULL or group_id = ?', 0]).find_by_surveytype(surveytype)
  end
  
  def self.default_letters_exist?
    Survey.surveytypes.all? { |surveytype| Letter.find_default(surveytype) }
  end
  
  def surveytype_exist
    "Der findes allerede et brev for denne skematype. Har du valgt den rigtige gruppe?"
  end

  def self.get_conditions(type, surveytype = nil, group_id = nil, follow_up = nil, include_null = false)
    query = ["`type` = '#{type}'"]
    if !surveytype.blank?
      # puts "filter letter surveytype #{options[:survey][:surveytype]}"
      s_query = (!query.first.blank? ? "and surveytype = ? " : "surveytype = ? ")
      s_query << "or surveytype is null " if include_null
      query.first << s_query
      query << surveytype
    end
    if !group_id.blank?
      # puts "filter letter group_id #{options[:group][:id]}"
      g_query = (!query.first.blank? ? "and group_id = ? " : "group_id = ? ")
      query.first << g_query
      query << group_id
    end
    puts "follow_up: #{follow_up}"
    if !follow_up.blank?
      # puts "filter letter follow_up #{options[:follow_up]}"
      f_query = (!query.first.blank? ? "and follow_up = ? " : "follow_up = ? ")
      f_query = "or follow_up is null" if include_null
      query.first << f_query
      query << follow_up
    end
    {:conditions => query}
#    @letters = Letter.all(:conditions => query)
  end

  def self.filter(options = {})
    type = options[:type]
    surveytype = options[:survey] && options[:survey][:surveytype]
    group_id = options[:group] && options[:group][:id] || nil
    follow_up = options[:follow_up] && !options[:follow_up][:follow_up].blank? && options[:follow_up][:follow_up].to_i
    query = [""]
    cond = Letter.get_conditions(type, surveytype, group_id, follow_up)
    puts "conditions: #{cond.inspect}"
    @letters = 
    if !cond[:conditions].first.blank?
      Letter.with_cond(cond).in_center(options[:center_id])
    else
      Letter.in_center(options[:center_id])
    end
  end
end
