# encoding: utf-8
class Center < Group
  has_many :teams, :dependent => :destroy
  has_many :journals #, :dependent => :destroy  # should never delete journals. TODO: some way to reclaim deleted/dangling journals
  has_many :subscriptions #, -> { includes(:periods) } #, :include => [:survey, :periods], :dependent => :destroy
  has_many :periods 
  has_many :surveys, -> { order('position').uniq }, :through => :subscriptions
  has_one  :center_info
  has_many :users,
           -> { where login_user: 0 }, class_name: 'User', dependent: :destroy
           # :class_name => 'User',
           # :conditions => 'users.login_user = 0',
           # :dependent => :destroy
  has_many :login_users,
           -> { where login_user: 1 }, class_name: 'User', dependent: :destroy
           # :class_name => 'User',
           # :conditions => 'users.login_user = 1',
           # :dependent => :destroy
  has_many :all_users, class_name: 'User', dependent: :destroy
  has_many :survey_answers           
	has_many :center_settings
	
  validates_format_of :code, :with => /\A[0-9][0-9][0-9][0-9]\z/ #:is => 4 #, :message => "skal være 4 cifre"
  validates_uniqueness_of :code #, :message => "skal være unik"
  # validates_uniqueness_of :title

  attr_accessible :center_info
  
  scope :search_title_or_code, lambda { |phrase| { :conditions => ["groups.title LIKE ? OR groups.code LIKE ?", phrase = "%" + phrase.sub(/\=$/, "") + "%", phrase] } }

  scope :order_by, lambda { |column, order|
    puts "column, order: #{column} #{order}"
    if ['title', 'code', 'created_at'].include?(column)
      order("#{column} #{order == 'desc' && 'desc' || 'asc'}")
    else
      order(' title desc')
    end
  }
  
  attr_accessor :subscription_service, :subscription_presenter
  # def validate
  #   unless self.code.to_s.size == 4
  #     errors.add("code", "skal være 4 cifre")
  #   end
  # end
  
  # team code must be unique within the same center
  # def validate_on_create
  #   if self.code.to_s.length != 4
  #     errors.add(:code, "skal være fire cifre")
  #   end
  #   if Center.find_by_code(:code)
  #     errors.add(:id, "skal være unik")
  #   end
  # end
  
  def center
    self
  end

  def center_info=(attributes)
    self.center_info && self.build_center_info(attributes) || CenterInfo.new(attributes)
    # if self.center_info
    # self.center_info.build(attributes)
  end
  
  def city; center_info && center_info.city; end
  def street; center_info && center_info.street; end
  def zipcode; center_info && center_info.zipcode; end
  def telephone; center_info && center_info.telephone; end
  def person; center_info && center_info.person; end
  def ean; center_info && center_info.ean; end
    
  def get_name
    title
  end
  
  def get_alt_id
    alt_id = get_setting('alt_id')
    alt_id_name = alt_id && alt_id.value || "Projektnr"
  end

  def get_setting(name)
    setting = center_settings.first(:conditions => ["name = ?", name])
  end

  # returns subscription for the specified survey
  def get_subscription(survey_id) # TODO: include periods
    (s = self.subscriptions.by_survey(self.id, survey_id)) && s.first
  end
  
  # returns subscribed surveys
  def subscribed_surveys # TODO: include periods
    subscriptions.where(:state => 1).map { |sub| sub.survey }.sort_by { |s| s.position }
  end
  
  def subscribed_surveys_in_age_group(age) # TODO: include periods
    surveys = subscribed_surveys.select do |survey|
      # be a bit flexible in which surveys can be used for which age groups, fx 11-16 can be used up to 18 years
      age_flex = (survey.age =~ /16|17|18/) && 4 || 1
      # survey.prefix != "info" && 
      (survey.age_group === age or survey.age_group === (age+2) or survey.age_group === (age-age_flex))
    end
	  
    if self.center_id == 1 && age >= 18
	  
    else
	surveys = surveys.select {|s| s.id < 10}  # don't show Oplysningsskema for other centers (and below 18 years of age)
    end
    surveys
  end
    
  # increment subscription count - move to journal_entry, higher abstraction
  # def use_subscribed(survey) # TODO: include periods
  #   # find subscription to increment, must be same as is journal_entry
  #   subscription = self.subscriptions.by_survey(survey) 
  #   return false unless Subscription
  #   subscription.copy_used!  #  if sub.nil?  => no abbo
  # end

  # shows no. used questionnaires in subscriptions
  def used_subscriptions # TODO: include periods
    self.subscriptions.inject(0) { |memo,sub| sub.copies_used + memo;  }
  end

  # did center ever pay a subscription?
  def paid_subscriptions? # TODO: include periods
    !self.subscriptions.map { |sub| sub.periods.paid }.flatten.empty?
  end

  def subscription_presenter(subscriptions = nil)
    @subscription_presenter ||= SubscriptionPresenter.new(self, subscriptions)
  end

  def subscription_service
    @subscription_service ||= SubscriptionService.new(self)
  end

  
  # return the next team id. Id must be highest id so far plus 1, and if doesn't exist
  def next_team_code
    highest_code = Team.where(['center_id = ?', self.id]).maximum('code')
    highest_code && highest_code.succ || 1
  end
    
  def next_journal_code(code = nil)
    highest_code = Journal.where(['center_id = ?', self.id]).maximum('code')
    return code if !code.nil? && highest_code == code
    highest_code && highest_code.succ || 1 # Journal.find(highest_id).code.succ || 1
  end

  # returns id codes of all journals in center
  def journal_codes
    self.journals.collect { |j| j.code }
  end


  protected
  
  # returns ids of all teams in center
  def team_ids
    self.teams.collect { |t| t.code }
  end

  
  validates_uniqueness_of :title, 
                          :message => 'er navnet på et allerede eksisterende center.'
                          
# TODO, does not work  # validates_length_of     :code, :is => 4,
                          # :message => ': skal være på 4 cifre'

  validates_uniqueness_of :code, 
                          :message => 'er ID for et allerede eksisterende center.'                          
end
