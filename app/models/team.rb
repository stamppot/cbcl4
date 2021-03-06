# encoding: utf-8

class Team < Group
  belongs_to :center
  has_many :journals, :foreign_key => :group_id

  scope :with_center, -> { includes(:center) }
  scope :with_journals, -> { includes(:journals) }
  scope :in_center, -> (center) { where(:center_id => (center.is_a?(Center) ? center.id : center)) }
  
  # scope :in_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }

  # team code must be unique within the same center
  def validate_on_create
    if self.center.nil?
      errors.add(:center, "ikke angivet")
    end
    if self.center && self.center.teams.collect { |t| t.code }.include?(code)
      errors.add(:id, "skal være unik")
    end
  end

  def get_name
    title
  end
  
  def has_member?(user)
    self.users.include? user
  end
  
  # member of center AND NOT member of team
  def only_center_has_member?(user)
    !self.has_member?(user) and self.center.all_users.include?(user)
  end
    
  # center (and possible team) has member
  def center_has_member?(user)
    self.center.all_users.include? user
  end
  
  # returns full code (center-team)
  def team_code
    "#{center.code}-#{self.code}"
  end

  def survey_answers
    # get all journals in team, journal_entries, then survey_answers
    self.journals.map { |j| j.journal_entries(:include => :survey_answer).answered.map {|je| je.survey_answer} }
    # or just get journal_ids directly
  end

  def login_users
    self.journals.map { |j| j.journal_entries }.flatten.map {|entry| entry.login_user}.compact
  end
  
  def journals_needing_reminders
    self.journals
  end
  
  def self.per_page
    15
  end
  
  
  protected

  # validates_uniqueness_of :title, 
  #                         :message => 'er navnet på et allerede eksisterende team.',
  #                         :if => Proc.new { |group| current_user.teams.map { |t| t.title }.include? group.title }

  validates_numericality_of :code, 
                            :message => 'skal være 1-4 cifre.'
                                                                                
  validates_presence_of   :center,
                          :message => ': center skal vælges',
                          :if => Proc.new { |group| group.class.to_s != "Center" }
end