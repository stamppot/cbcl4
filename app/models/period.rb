class Period < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :center

  attr_accessible :active, :used, :subscription
  
  scope :active, -> { where('active = ?', true) }
  scope :inactive, -> { where('active = ?', false) }
  scope :paid, -> { where('paid = ?', true).order('paid_on DESC') }

  attr_accessor :state

  def after_initialize
    self.start ||= Date.now if new_record?
  end

  # def survey
  #   self.survey_id && Survey.find(self.survey_id) || nil
  # end

  # def center
  #   self.center_id && Center.find(self.center_id) || nil
  # end
  
  def active?
    self.active
  end
  
  def start_on
    self.created_on
  end

  def stopped_on
    self.paid_on
  end

  # def stopped_on=(val)
  #   self.paid_on = val.to_date
  # end
  
  def copy_used!
    if self.active?
      self.used = 0 unless self.used
      self.used += 1
      self.save
    else
      false
    end
  end

  def pay!
    self.paid = true
    self.paid_on = DateTime.now
    self.active = false
    self.save  # check that paid_on is updated
  end

  def undo_pay!
    self.paid = false
    self.paid_on = nil
    self.active = true
    self.save
  end
  
  def reset!
    self.used = 0
    self.save
  end

  def fix_used(update = false)
    counter = PeriodsCounter.new
    summary = counter.real_total_in_period(self.center_id, self.created_on, self.paid_on)
    real = summary.per_survey.key?(self.survey_id) && summary.per_survey[self.survey_id] || 0
    if used != real
      puts "used: #{used}  real: #{real}"
      self.used = summary.per_survey[self.survey_id]
      self.save if update
    else
      puts "OK #{used}  p.id #{id}  c: #{center.id}  s: #{survey_id}"
    end
  end

  def check_used(update = false)
    counter = PeriodsCounter.new
    summary = counter.real_total_in_period(self.center_id, self.created_on, self.paid_on)
    real = summary.per_survey.key?(self.survey_id) && summary.per_survey[self.survey_id] || 0
    if used != real
      return "used: #{used}  real: #{real}"
    end
  end
end