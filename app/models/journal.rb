# encoding: utf-8
# require 'facets/dictionary'
#require 'rake'
# require 'hashery'
class Journal < ActiveRecord::Base #< Group
  belongs_to :center
  belongs_to :group

  # has_many :journal_entries, :order => 'created_at', :dependent => :destroy
  has_many :journal_entries, -> { order('created_at') }, :dependent => :destroy
  has_many :login_users, :through => :journal_entries, :source => :journal_entries
  has_many :surveys, :through => :journal_entries
  has_many :survey_answers
  has_many :csv_answers
  has_many :score_rapports, :through => :survey_answers
  has_many :journal_click_counters # has one per user  
  
  has_many :answered_entries_by_personnel, -> { includes(:survey).where('journal_entries.state = 5').order('journal_entries.answered_at') },
           :class_name => 'JournalEntry' #,
           # :include => [:survey],
           # :conditions => 'journal_entries.state = 5',  # answered
           # :order => 'journal_entries.answered_at'
  has_many :answered_entries_by_login_user, -> { where('journal_entries.state = 6').order('journal_entries.answered_at') },
           :class_name => 'JournalEntry' #,
           #:conditions => 'journal_entries.state = 6',  # answered
           #:order => 'journal_entries.answered_at'
	has_many :answered_entries, -> { where('journal_entries.state >= 5').order('journal_entries.answered_at') },
	         :class_name => 'JournalEntry' #,
	         # :conditions => 'journal_entries.state >= 5',  # answered
	         # :order => 'journal_entries.answered_at'
  has_many :not_answered_entries, -> { where('journal_entries.state < 5').order('journal_entries.created_at') },
           :class_name => 'JournalEntry'

           # :conditions => 'journal_entries.state < 5',  # not answered
           # :order => 'journal_entries.answered_at'
  # default_scope -> { order('created_at DESC') }

  attr_accessible :code, :title, :sex, :birthdate, :birthdate, :birthdate, :nationality, :parent_name, :parent_email, :alt_id, :group, :center_id, :group_id

  after_save    :expire_cache
	after_create  :index_search, :expire_cache
  after_destroy :expire_cache
  after_destroy :destroy_journal_entries
  
  # ID is mandatory
  # validates_presence_of :code #, :message => "ID skal gives"
  validates_presence_of :name#, :message => "Navn skal angives"
  # validates_presence_of :sex #, :message => "Køn skal angives"
  # validates_presence_of :nationality #, :message => "Nationalitet skal angives"
  validates_associated :group #, :message => "Et Center eller team skal angives"
  # validates_presence_of :group
  validates_associated :center
  validates_presence_of :center

  # journal code must be unique within the same center
  validates_uniqueness_of :code, :scope => :center_id #, :message => "bruges allerede. Vælg andet ID."
  # TODO: validates_associated or existence_of (see Advanced Rails recipes or Rails Way)
  validates_presence_of :sex, :message => "Køn skal angives"
  validates_presence_of :nationality, :message => "Nationalitet skal angives"

  validates_length_of :alt_id, :maximum => 22, :allow_nil => true, :message => 'skal have mindre end 22 bogstaver.' 

  scope :and_entries, -> { includes(:journal_entries) }
  # scope :and_login_users, :include => { :journal_entries => :login_user }
  scope :for_group, lambda { |group| group && where(:group_id => (group.is_a?(Group) ? group.id : group)) || scoped }
  scope :in_center, lambda { |group| group && where(:center_id => (group.is_a?(Center) ? group.id : group)) || scoped }
  scope :by_code, -> { order('code ASC') }
  scope :order_by, lambda { |column, order|
    puts "column, order: #{column} #{order}"
    if ['title', 'code', 'birthdate', 'created_at'].include?(column)
      order("#{column} #{order == 'desc' && 'desc' || 'asc'}")
    else
      order(' created_at desc')
    end
  }
  scope :for_groups, lambda { |group_ids| where(:group_id => group_ids) }  # { :conditions => ['parent_id IN (?)', group_ids] } }
  scope :for, lambda { |journal_id| where(:id => journal_id) }
  scope :all_groups, lambda { |group_ids| where(['group_id IN (?)', group_ids]) }
  scope :all_groups, lambda { |parent| where(parent.is_a?(Array) ? ["group_id IN (?)", parent] : ["group_id = ?", parent]) }


  define_index do
     # fields
     indexes :title, :sortable => true
     indexes :code, :sortable => true
     indexes :cpr, :sortable => true
     indexes :alt_id, :sortable => true
		 # indexes center_id
     # attributes
     # has group_id, center_id, created_at, updated_at
     has group_id, center_id, created_at, updated_at
     set_property :delta => true
   end

  def self.per_page 
    20
  end
  # def validate
  #   unless self.code.to_s.size == Journal.find_by_code_and_center_id(self.code, self.center_id)
  #     errors.add("code", "skal være 4 cifre")
  #   end
  # end 

  def self.search_journals(user, phrase)
    journals =
    if phrase.empty?
      []
    elsif user.has_role?(:superadmin)
      Journal.search(phrase, :order => "created_at DESC", :per_page => 44440)
    elsif user.has_role?(:centeradmin)
      # user.centers.map {|c| c.id}.inject([]) do |result, id|
      #   result += Journal.search(phrase, :with => { :center_id => user.centers.map(&:id) }, :order => "created_at DESC", :per_page => 44440)
      # end
      Journal.search(phrase, :with => { :center_id => user.centers.map(&:id) }, :order => "created_at DESC", :per_page => 44440)
    else
      # user.center_and_teams.inject([]) do |result, g|
        # result += 
        Journal.search(phrase, :with => {:group_id => user.center_and_teams.map(&:id) }, :order => "created_at DESC", :per_page => 40)
      # end
    end
  end

  def self.run_rake(task_name)
    #load File.join(RAILS_ROOT, 'lib', 'tasks', 'thinking_sphinx_tasks.rake')
    #Rake::Task[task_name].invoke
  end

  # def parent=(group)

  # end

  def children 
    []
  end

  def parent_or_self
    self.is_a?(Center) && self || self.center
  end
  
  def set_cpr_nr
    dato = self.birthdate.to_s.split("-")
    dato[0] = dato[0][2..3]
    self.cpr = dato.reverse.join
  end

  def update_birthdate!(params)
    new_birthdate = Date.new params["birthdate(1i)"].to_i, params["birthdate(2i)"].to_i, params["birthdate(3i)"]
    return false if new_birthdate == self.birthdate
    birthdate = new_birthdate
    save
  end

  def get_name
    title
  end

  def has_follow_up?(entry)
    journal_entries.any? {|e| e.id != entry.id && e.survey_id == entry.survey_id && e.follow_up == entry.follow_up}
  end

  def index_search
		#Journal.run_rake("rake thinking_sphinx:reindex")
	end

  def follow_up_count
    journal_entries.map {|e| e.survey_id}.group_by {|c| c}.map {|c| c.second.size}.max
  end

  def expire
    Rails.cache.delete("j_#{self.id}")
		# Rails.cache.delete("journal_ids_user_#{self.id}")
		# Rails.cache.delete("journal_entry_ids_user_#{self.id}")
  end
  
  def expire_cache
    Rails.cache.delete("j_#{self.id}")
    # remove pagination caching for cached journal list for all teams in this center
    Rails.cache.delete_matched(/journals_groups_(#{self.center_id})/)
    Rails.cache.delete_matched(/journals_all_paged_(.*)_#{Journal.per_page}/)
    # Rails.cache.delete_matched(/journal_ids_user_(.*)/)
		self.group.users.map {|user| user.expire_cache}
  end
  
  def destroy_journal_entries
    self.journal_entries.compact.each { |entry| puts "Entry: #{entry.inspect}"; entry.destroy_and_remove_answers! }
  end
  
  # show all login-users for journal. Go through journal_entries
  def login_users
    self.journal_entries.collect { |entry| entry.login_user }.compact
  end
  
  # can a journal belong to one or more teams?  No, just one. Or a Center!
  # def team
  #   return parent
  # end
  
  def name
    self.title
  end

  def firstname
    self.title.split(' ').first
  end
  
  def birth_short
    birthdate && birthdate.strftime("%d-%m-%Y") || ""
  end

  def Journal.sexes
    {
      'dreng' => 1,
      'pige' => 2,
      'm' => 1,
      'f' => 2
    }
  end

  def sex_text
    Journal.sexes.invert[self.sex]
  end
 
  # sets the next journal code based on its center or current_user
  def next_journal_code(user)
    center = self.center && self.center || user.center
    return user.centers.map {|c| c.next_journal_code}.max if user && user.centers.size > 1
    center.next_journal_code
  end
  
  # returns full id, qualified with center and team ids
  def qualified_id
    qualified_code + "-" + "%04d" % (self.code || 0)
  end
  
  # code of center and team
  def qualified_code
    team_id = group.instance_of?(Center) && 0 || group.code
    "%04d" % 
    center.code + 
    "-" + 
    "%04d" % 
    team_id #  group.code.to_s.rjust(3, "0")
  end
  
  # creates entries with logins
  def create_journal_entries(surveys, follow_up = 0, save = true)
    return [] if surveys.empty?
    surveys.map do |survey|
      entry = JournalEntry.new({:survey => survey, :state => 2, :journal => self, :follow_up => follow_up})
      entry.group_id = self.group_id || self.center_id
      entry.journal_id = self.id
      entry.center_id = self.center_id
      # login_number = "#{self.code}#{survey.id}"
      login_user = entry.make_login_user
      unless login_user.valid?
        puts "login_user errors: #{login_user.errors.inspect}"
      end
      entry.login_user.save && entry.save if save
      entry
      # if entry.valid?
      #   entry.print_login!
      #   entry.login_user.save
      # end
      # entry.expire_cache(current_user) # expire journal_entry_ids
    end
    # return self
  end
    
  def header_data
    data = to_csv
    data.inject([[],[]]) do |col, tuple|
      item, val = *tuple.to_a.first
      col[0] << item
      col[1] << val
      col
    end
  end
  
  # info on journal in array of hashes
  def info
		settings = CenterSetting.find_by_center_id_and_name(self.center_id, "use_as_code_column")
    c = Dictionary.new # ActiveSupport::OrderedHash.new
    c["ssghafd"] = self.group.group_code
    c["ssghnavn"] = self.center.title
    c["safdnavn"] = self.group.title
    c["pid"] = settings && eval("self.#{settings.value}") || self.code
    c["projekt"] = self.alt_id || ""
    c["pkoen"] = self.sex
    c["palder"] = get_age(self.birthdate, self.created_at)  # alder på oprettelsesdato
    c["pnation"] = self.nationality
    c["besvarelsesdato"] = self.created_at.strftime("%d-%m-%Y")
    c["pfoedt"] = self.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
    c
  end
  
  # def export_info
		# settings = CenterSetting.find_by_center_id_and_name(self.center_id, "use_as_code_column")
  #   c = {}
  #   c[:ssghafd] = self.parent.group_code
  #   c[:ssghnavn] = self.center.title
  #   c[:safdnavn] = self.group.title
  #   c[:pid] = settings && eval("self.#{settings.value}") || self.code
  #   c[:projekt] = self.alt_id
  #   c[:pkoen] = self.sex
  #   c[:palder] = get_age(self.birthdate, self.created_at)  # alder på besvarelsesdatoen
  #   c[:pnation] = self.nationality
  #   c[:besvarelsesdato] = "-" #self.created_at.strftime("%d-%m-%Y")
  #   c[:pfoedt] = self.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
  #   c
  # end

  def age
    ( (Date.today - self.birthdate).to_i / 365.25).floor
  end

  def get_age(birth_date, end_date)
    ( (end_date.to_datetime - birth_date).to_i / 365.25).floor
  end

  # protected
  
  # validates_presence_of   :parent,
  #                         :message => ': overordnet gruppe skal vælges',
  #                         :if => Proc.new { |group| group.class.to_s != "Center" }
                          
end
