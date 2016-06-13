class JournalEntry < ActiveRecord::Base
  belongs_to :journal #, :touch => true
  belongs_to :survey
  belongs_to :survey_answer, :touch => true #, :dependent => :destroy #, :touch => true
  belongs_to :login_user, :class_name => "LoginUser", :foreign_key => "user_id", :dependent => :destroy
  belongs_to :group, :class_name => "Group"

  # accepts_nested_attributes_for :journal, :group
  # validates_associated :login_user
  # validates_uniqueness_of :follow_up, :scope => :journal_id #, :message => "bruges allerede. Vælg andet ID."
  # validate :follow_up_validation
  attr_accessible :survey, :state, :journal, :follow_up #, :group_id

  scope :by_id_and_journal, lambda { |id, journal_id| where('id = ? AND journal_id = ?', id, journal_id) }
  scope :and_login_user, -> { includes(:login_user) }
  scope :and_survey_answer, -> { includes([:survey, :survey_answer]) }
	scope :in_center, lambda { |center_id| { :joins => :journal, :conditions => ["journal_entries.center_id = ?", center_id] } }
  scope :with_surveys, lambda { |survey_ids| { :joins => :survey_answer,
   :conditions => ["survey_answers.survey_id IN (?)", survey_ids] } }
  scope :for_surveys, lambda { |survey_ids| where("survey_id IN (?)", survey_ids) }
  scope :unanswered, -> { where('state < 5') }
  scope :answered, -> { where('state = 5') }
  scope :answered_by_login_user, -> { where('state = 6') }
  scope :for_states, lambda { |states| where("journal_entries.state IN (?)", states) }
  scope :with_cond, lambda { |cond| cond }
  scope :between, lambda { |start, stop| where('journal_entries.created_at' => start..stop) } 
  scope :answered_between, lambda { |start, stop| where('journal_entries.answered_at' => start..stop) } 
  scope :first_answered, -> { where('answered_at is not null').order('journal_entries.answered_at asc').limit(1) }
  scope :last_answered, lambda { { :conditions => ['answered_at is not null'], :order => 'journal_entries.answered_at desc', :limit => 1}}
  scope :active_state, lambda { |state| where("#{self.get_status_query(state)}", state) }
  scope :with_followup, lambda { |follow_up| follow_up && where(:follow_up => follow_up) }

  # scope :done, -> { includes(:survey_answer).where('survey_answers.done = 1') }

  # def self.follow_ups
  #   [["Diagnose", 0], ["1. opfølgning", 1], ["2. opfølgning", 2], ["3. opfølgning", 3], ["Afslutning", 4]]
  # end

  def self.get_status_query(state)
    case state
    when "" then ""
    when "0" then "reminder_status is null or reminder_status = ?"
    when "1" then "reminder_status = ?"
    end
  end

  def get_follow_up
    self.follow_up ||= 0
    FollowUp.get[follow_up].first
  end

  def next_survey
    self.next && (je = JournalEntry.find_by_id(self.next)) && je && je.survey.title || ""
  end
  
  # def follow_up_validation
  #   is_invalid = journal.has_follow_up?(self)
  #   errors.add(:follow_up, "Journalen har allerede et skema med denne opfølgning: #{get_follow_up}") if is_invalid
  # end

  def get_title
    t = survey.title.gsub("skema", "")
    t += " #{self.get_follow_up}"
  end

  def expire_cache(user)
    # Rails.cache.delete("journal_entry_ids_user_#{user.id}")
  end
  
  def make_survey_answer
    self.survey_answer ||= self.build_survey_answer(:survey => self.survey,
                             :sex => self.journal.sex,
                             :age => self.journal.age, # age at moment of answering
                             :nationality => self.journal.nationality,
                             :journal_entry_id => self.id,
                             :journal_id => self.journal_id,
                             :surveytype => self.survey.surveytype,
                             :center_id => self.journal.center_id)
    self.survey_answer.alt_id = self.journal.alt_id
    self.survey_answer.team_id = self.journal.group_id if self.journal.group.is_a?(Team)
    self.survey_answer.journal_entry_id = self.id
    self.survey_answer.survey_id = self.survey.id
    self.survey_answer.follow_up = self.follow_up
    self.survey_answer.sex = self.journal.sex
    self.answered_at = self.survey_answer.updated_at = DateTime.now
    # self.answered!
    self.survey_answer.save && self.save
    self.survey_answer
  end

  # deletes login user
  def remove_login!
    return self.login_user.destroy if self.login_user
    return self.login_user.nil?
  end

  def is_parent_survey?
    [1,2].include?(survey_id)
  end
  
  def is_teacher_survey?
    [3,4].include? survey_id
  end

  def destroy_and_remove_answers!
    self.remove_login!
    self.survey_answer.destroy if self.survey_answer
  end
  
  def valid_for_csv?
    if survey_answer_id && survey_id && journal_id && answered?
      return self
    else
      return nil
    end
  end
  
  # increment subscription count
  # 19-9 find better name
  def increment_subscription_count(survey_answer)
    self.survey_answer = survey_answer
    self.answered_at = Time.now
    center = self.journal.center
    
    # find subscription to increment, must be same as is journal_entry
    subscription = center.get_subscription(survey_answer.survey_id)  #s.detect { |sub| sub.survey.id == survey.id }
    return false if subscription.nil?                               # no abbo exists
    subscription.copy_used!
    self.save    # saves objects
    rescue ActiveModel::MissingAttributeError
      logger.info "MissingAttributeError draft! #{self.inspect}"
  end
    
  def status
    JournalEntry.states.invert[self.state]
  end

  def answer_status
    return "Besvaret" if [5,6].include? self.state
    return "Ubesvaret" if self.state == 2
    return status
  end
  
	def answered_by
		if !survey_answer.blank? && survey_answer.answered_by.to_i > 0
			role = Role.find(survey_answer.answered_by == 88 && 15 || survey_answer.answered_by)
			return role.title
		end
  end

  def answered?
    (self.state == JournalEntry.states['Elektronisk'] || self.state == JournalEntry.states['Papir']) &&
    (self.state != JournalEntry.states['Ubesvaret'] || self.state != JournalEntry.states['Sendt ud'] || self.state != JournalEntry.states['Venter'])
  end                                   
                                        
  def answered!                           
    self.state = JournalEntry.states['Elektronisk']  
    self.save!
  end

  def answered_paper!
    self.state = JournalEntry.states['Papir']  
    puts "#{self.group_id}"
    self.save!
  end

	def answered_paper?
    self.state == JournalEntry.states['Papir']  
  end

  def not_answered?
    self.state != JournalEntry.states['Elektronisk'] || self.state != JournalEntry.states['Papir'] # Ubesvaret
  end
  
  def not_answered!
    self.state = JournalEntry.states['Ubesvaret']   # Ubesvaret
    self.save!
  end
  
  def draft?
    self.state == JournalEntry.states['Kladde']  # Svarkladde er påbegyndt
  end
  
  def draft!
    self.state = JournalEntry.states['Kladde']   # Svarkladde
    self.save!
  end

  def awaiting_answer?
    self.state == JournalEntry.states['Venter']  # Venter
  end

  def awaiting_answer
    self.state = JournalEntry.states['Venter']   # Venter
  end
  
  def awaiting_answer!
    self.state = JournalEntry.states['Venter'] # 'Venter'
    self.save
  end
  
  def print_login?
    self.state == print_login
  end

  def print_login
    self.state = JournalEntry.states['Sendt ud'] # print eller skal sendes
  end
  
  def print_login!
    self.print_login
    self.save
  rescue => e
    puts "JournalEntry.print_login!: #{e.inspect}"
  end
  
  # reset state unless it has been answered
  def remove_login_user!
    self.user = nil    # set to unanswered unless answered
    self.state = JournalEntry.states[JournalEntry.states.invert[1]] unless self.state == JournalEntry.states[JournalEntry.states.invert[4]]
    self.save
  end
  
  def JournalEntry.for_parent_with_state(group, states)
    # puts "for_parent_with_state states: #{states}"
    JournalEntry.for_states(states).where('journal_entries.group_id = ?', (group.is_a?(Group) && group.id || group)).joins(:journal) #, :joins => :journal)
  end
  
  def JournalEntry.states  # ikke besvaret, besvaret, venter på svar (login-user)
    { #'Fejl'       => 0,
      # 'Ubesvaret'  => 1,
      'Sendt ud'   => 2,
      # 'Venter'     => 3,   # venter paa at login-bruger svarer paa skemaet
      'Kladde'     => 4,
      'Papir'   	 => 5,    # besvaret af behandler
			'Elektronisk' => 6,		# besvaret af login-bruger
      # 'Rykket'      => 7,
      # 'Afsluttet'   => 8
       }
  end
  
  def JournalEntry.status_name
    {
      [2,3,4,5,6] => "Alle",
      [2,4] => "Ubesvarede",
      [4] => "Kladde",
      [5,6] => "Besvarede"
    }
  end

  def reminder_state
    return "" if reminder_status.nil?
    JournalEntry.reminder_states.invert[self.reminder_status]
  end

  def set_reminder_state(status)
    value = JournalEntry.reminder_states[status]
    # puts "status: #{status}, value: #{value}"
    self.reminder_status = value if value
  end

  def JournalEntry.reminder_states # om de skal trækkes med ud i trafiklys-funktion
    {
      '' => 0,
      'Passiv' => 1 #,
      # 'Afsluttet' => 9 
    }
  end

  def update_date(created)
    age = ((created - self.journal.birthdate).to_i / 365.25).floor
    self.survey_answer.age = age
    self.answered_at = created
    self.save
    
    self.survey_answer.created_at = created
    self.survey_answer.save
    
    csv_score_rapport = CsvScoreRapport.find_by_survey_answer_id(self.survey_answer_id)
    if csv_score_rapport
      csv_score_rapport.destroy
    end
    csv_survey_answer = CsvSurveyAnswer.find_by_journal_entry_id(self.id)
    if csv_survey_answer
      csv_survey_answer.created_at = created
      csv_survey_answer.age = age if csv_survey_answer
      csv_survey_answer.save
    end
    score_rapport = ScoreRapport.find_by_survey_answer_id(self.survey_answer_id)
    if score_rapport
      score_rapport.regenerate
    end
  end

  def make_login_user(password = nil)
    login = journal.group.login_prefix
    group_name = journal.group.group_name_abbr
    params = LoginUser.create_params(login, group_name)
    pw = password && {:password => password, :password_confirmation => password} || PasswordService.generate_password
    login_user = LoginUser.new(params)
    # set protected fields explicitly
    login_user.center_id = journal.center_id
    login_user.roles << Role.get(:login_bruger)
    login_user.groups << journal.group
    login_user.password, login_user.password_confirmation = pw.values
    login_user.password_hash_type = "md5"
    login_user.last_logged_in_at = 10.years.ago
    self.password = pw[:password]
    self.login_user = login_user
    # unless login_user.valid?
    #   raise RuntimeError("invalid LoginUser: #{login_user.inspect}")
    # end
    return login_user
  end

end

