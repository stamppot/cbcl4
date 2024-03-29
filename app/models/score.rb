# encoding: utf-8

class Score < ActiveRecord::Base
  has_many :score_items, :dependent => :delete_all
  has_many :score_refs, :dependent => :delete_all

  belongs_to :survey
  belongs_to :score_scale

  attr_accessible :survey, :score_scale, :title, :sum, :score_scale_id
  
  scope :for_survey, lambda { |survey_id| where("scores.survey_id = ?", survey_id) }
  scope :with_survey_and_scale, -> { includes([:survey, :score_scale]) }
  acts_as_list :scope => :score_group
  
  validates_presence_of :title, :message => ': navn skal gives'
  validates_presence_of :survey, :message => ': et skema skal vælges'
  
  attr_accessor :action # attribute not saved in db, to help with ajax

  
  # creates score items for selected surveys when a score is created
  def create_score_items(surveys)
    surveys.each do |survey|
      item = ScoreItem.new
      item.survey_id = survey
      self.score_items << item
    end
    self.save
  end
  
  # returns score ref with the right age_group and gender
  def find_score_ref(age, sex)
    score_ref = self.score_refs.detect do |score_ref|
      score_ref.age_range === age && score_ref.gender == sex
    end
    if score_ref.nil?
      puts "age: #{age}  sex: #{sex}"
      puts "#{self.score_refs.inspect}"
      return false 
    end
    return score_ref
  end
  
  # delegates calculation to the right score_item
  def calculate(survey_answer)
    s_type = survey_answer.surveytype
    
    # find matching type in score_items, so only the score item for the type of survey is calculated
    score_item = self.score_items.first
    score_ref  = self.find_score_ref(survey_answer.age, survey_answer.sex)
    
    mean = score_ref && score_ref.mean || 0.0
    missing = 0
    result = 0
    result, missing, hits, answered_items = score_item.calculate(survey_answer) if score_item
    row_result = [result]  # other survey scores are added as columns
    return row_result << :normal << mean << missing << hits << 
      (survey_answer.survey.age) unless score_ref  # guard clause when no score_ref exists
      
    # res = row_result.first.to_i
    percentile = if (result && score_ref && score_ref.percent98) && result >= score_ref.percent98
      :percentile_98
    elsif (result && score_ref && score_ref.percent95) && result >= score_ref.percent95
      :percentile_95
    elsif score_ref.mean > 0.0
      :deviation
    else
      :normal
    end
    return [result, percentile, mean, missing, hits, survey_answer.survey.age]
  end

  def result(survey_answer, journal)
    self.calculate(survey_answer, journal).first
  end
  
  def percentile(survey_answer, journal)
    self.calculate(survey_answer, journal)[1]
  end
  
  def sum_type
    sum_types.invert[self.sum]
  end
  
  def scale_text
    self.score_scale.title
  end

  def sum_types
    Score.default_sum_types
  end
    
  def scales
    ScoreScale.all.map { |scale| [scale.title, scale.id] }
  end

  def item_qualifiers
    Score.default_qualifiers
  end

  # all, specified, or except items
  def set_items_count
    item = self.score_items.first  # there's only one score_item per score
    return unless item
    if Score.default_qualifiers.invert[item.qualifier] == 'valgte'  # count items
      self.items_count = item.items.split(',').size
    elsif Score.default_qualifiers.invert[item.qualifier] == 'alle' # get ratings_count from survey
      self.items_count = self.survey.question_with_most_items.ratings_count
    elsif Score.default_qualifiers.invert[item.qualifier] == 'undtaget' # difference with survey ratings_count 
      self.items_count = self.survey.question_with_most_items.ratings_count - item.items.split(',').size
    end
    self.save
    self.items_count
  end
  
  def <=>(other)
    if self.short_name == other.short_name
      self.scale <=> other.scale
    else
      self.short_name <=> other.short_name
    end
  end

  def to_s
    "<br>Score: #{id}" + "<br>" + title + "<br>" + "Skema: #{short_name}" + "<br>" + "Tælling: #{sum_type}" + "<br>" + "Skala: #{scale}" + "<br>"
  end
  
  def score_headers(survey)
    Score.for_survey(survey.id).map {|s| s.title }
  end
  
  # used to generate score_result
  def Score.percentile_string(percentile, mean)
    case percentile
    when :percentile_98 then "(#{mean.to_danish}) **"  
    when :percentile_95 then "(#{mean.to_danish}) *&nbsp;"
    when :deviation then "(#{mean.to_danish}) &nbsp;&nbsp;&nbsp;"
    when :normal then ""
    else ""
    end
  end

  def self.last_updated
    Score.first(:order => 'updated_at desc', :select => :updated_at).updated_at
  end
  
  private

  def Score.default_sum_types
    {
      'normal' => 1,
      'dicotomi' => 2
    }
  end

  def Score.default_qualifiers
    {
      'valgte' => 0,
      'alle'   => 1,
      'undtaget' => 2
    }
  end

  
end
