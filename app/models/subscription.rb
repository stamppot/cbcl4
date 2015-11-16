# encoding: utf-8

class Subscription < ActiveRecord::Base
  belongs_to :center
  belongs_to :survey
  has_many :periods #, :dependent => :delete_all

  before_validation :set_totals
  after_create :new_period!

  attr_accessible :total_used, :total_paid, :active_used, :center, :survey_id, :state

  scope :in_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }
  scope :by_survey, lambda { |center_id, survey| { :conditions => ['center_id = ? and survey_id = ?', center_id, (survey.is_a?(Survey) ? survey.id : survey)] } }
  
  scope :active, -> { where('state = ?', 1) }
  scope :inactive, -> { where('state = ?', 2) }
  scope :locked, -> { where('state = ?', 3) }
  scope :deleted, -> { where('state = ?', 4) }
  
  validates_presence_of :survey
  validates_presence_of :center

  validates_presence_of :total_paid
  validates_presence_of :total_used
  validates_presence_of :active_used
  
  def set_totals
    self.total_paid ||= 0
    self.total_used ||= 0
    self.active_used ||= 0
  end
  
  def new_period!
    self.periods.build(:active => true, :used => 0)
  end
  
  def Subscription.states
    Subscription.default_states
  end
  
  def states
    Subscription.default_states
  end
  
  def active?
    Subscription.default_states['Aktiv'] == self.state
  end
  
  def inactive?
    !(Subscription.default_states['Aktiv'] == self.state)
  end
  
  def activate!
    self.new_period! unless self.periods.active.empty?
    self.state = self.states['Aktiv']
    self.save
  end
  
  def deactivate!
    self.state = self.states['Inaktiv']
    self.save
  end

  def find_active_period
    active_period = self.periods.active.last
#    if active_period.nil?
#      new_copy = self.periods.new({:active => true, :used => 0})
#      new_copy.center_id = self.center_id # not accessible
#      new_copy.survey_id = self.survey_id
#      new_copy.start = DateTime.now
#      new_copy.save
#      active_period = new_copy
#    end
    active_period
  end
  
  def unpaid_used
    find_active_period.used
  end
  
  def paid_used
    total_used_subs = total_used || 0
    result = total_used_subs - find_active_period.used
    result < 0 && 0 || result
  end
  
  # subscribed survey has been used
  def copy_used!
    find_active_period.copy_used!
    self.total_used ||= 0
    self.active_used ||= 0
    self.total_used += 1   # total count
    self.active_used += 1
    self.save
  end

  # rolls back last paid copy, sums any use counts
  def set_last_as_unpaid
    active_period = self.find_active_period
    old_period = self.periods[-2]
    old_period.used += active_period.used
    self.total_used += self.active_used
    active_period.destroy && old_period.save && self.save
  end
  
  # def periods_used
  #   self.periods.map { |c| c.used }.sum
  # end
  
  def subscriptions_count
    result = SubscriptionsQuery.new.query_subscriptions_count(self)
  end  

  def self.subscriptions_count(center = nil, group_by = 'center_id')
    # TODO: cache
    result = # cache_fetch("subscriptions_count_#{center.id}", :expires_in => 10.minutes) do
      result = SubscriptionsQuery.new.query_subscriptions_count(center)
      result = result.group_by { |h| h[group_by].to_i } unless center
    # end
    result
  end
  
  def new_period!
    active_period = find_active_period
    active_period.pay!
    new_period = self.periods.new(:active => true, :subscription => self, :used => 0)
    new_period.survey_id = self.survey_id
    new_period.center_id = self.center_id
    new_period.save
  end

  # use when merging periods with no used surveys
  def merge_periods! #(date1, date2)
    active_periods = self.periods.active
    return if active_periods.size == 1 # nothing to do

    first_period = active_periods.shift
    # copy subsequent periods to first active
    active_periods.each_with_index do |period, i|
       first_period.used += period.used
     end
    active_periods.each { |p| p.destroy } if first_period.save
  end
  
  # pay active period
  def pay!
    active_period = find_active_period
    puts "PAY! #{self.inspect}"
    self.most_recent_payment = Date.today #.to_s(:db)
    active_period.pay!
		update_used_and_total_paid
		self.save
	  begin_new_period!
  end

	def update_used_and_total_paid
		self.total_paid ||= 0
		self.active_used ||= 0
		self.total_paid += self.active_used
		self.active_used = 0
		self.total_paid
		self.most_recent_payment = Date.today
		# puts "update_used_and_total_paid: total_paid #{total_paid}  active_used: #{active_used}"
	end
	
	# TODO: fix
  # def undo_pay!
  #   active_period = self.periods.active.last # find_active_period
  #   if active_period
  #     used = active_period.used
  #     if last_paid_period = self.periods.paid.last
  #       last_paid_period.used += used
  #       last_paid_period.undo_pay!
  #       self.most_recent_payment = last_paid_period.paid_on
  #       active_period.destroy
		# 		active_period = nil
  #     end
  #   end
  # end
  
  def summary(options = {})
    results = case options[:show]
    when "active" then periods.active
    when "paid"   then periods.paid
    else 
      periods
    end
    results.group_by { |c| c.created_on }
  end
   
  def begin_new_period!
		p = self.periods.last
		p.active = false
    if p.save
      new_period = self.periods.new(:active => true, :subscription => self, :used => 0)
      new_period.start = DateTime.now
      new_period.center_id = self.center_id
      new_period.survey_id = self.survey_id
      new_period.save
    end
  end

    # This method returns a hash which contains a mapping of user states 
    # valid by default and their description.
    def Subscription.default_states
      @default_states ||= {
        'Aktiv' => 1,
        'Inaktiv' => 2,
        'Låst' => 3,
        'Slettet' => 4
      }
    end

end