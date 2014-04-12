require 'csv'

class CsvSurveyAnswer < ActiveRecord::Base
  belongs_to :survey_answer
  belongs_to :survey
  belongs_to :journal_entry
  belongs_to :journal
  belongs_to :center
  belongs_to :team
  
  validates_uniqueness_of :survey_answer_id
  
  scope :by_survey_answer, lambda { |id| { :conditions => ['survey_answer_id = ?', id], :limit => 1 } }
  scope :by_journal_and_survey, lambda { |j_id, survey_id| { :conditions => ['journal_id = ? and survey_id = ?', j_id, survey_id], :limit => survey_ids.size, :order => 'survey_id' } }
  scope :by_survey_answer_and_surveys, lambda { |sa_id, survey_ids| { :conditions => ['survey_answer_id = ? and survey_id IN (?)', sa_id, survey_ids], :limit => survey_ids.size, :order => 'survey_id' } }  

  scope :between, lambda { |start, stop| { :conditions => { :created_at  => start...stop } } }
  scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start...stop } } }
  scope :from_date, lambda { |start| { :conditions => { :created_at  => start...(Date.now) } } }
  scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)...stop } } }
  # scope :for_survey, lambda { |survey_id| { :conditions => { :survey_id => survey_id } } }
  scope :for_survey, lambda { |survey_id| where(:survey_id => survey_id) }   # "csv_survey_answers.survey_id = ?", survey_id] } }
  scope :in_center, lambda { |center_id| { :conditions => ["csv_survey_answers.center_id = ?", center_id] } }
  scope :for_team, lambda { |team_id| { :conditions => ["csv_survey_answers.team_id = ?", team_id] } }

  attr_accessible :answer, :journal_id, :survey_answer_id, :center_id, :team_id, :survey_id, :journal_entry_id, :age, :sex, :created_at, :updated_at, :journal_info


  def to_csv(csv_survey_answers, survey_id)
    csv_survey_answers.first.variables
    output = CSV.generate(:col_sep => ";", :row_sep => :auto) do |csv_output|
      csv_output << (headers + survey_headers_flat(survey_ids).keys)  # header
      rows.each { |line| csv_output << line.gsub(/^\"|\"$/, "").split(";;") }
    end
  end
  
  def self.filter_params(user, options = {})
    options[:start_date]  ||= SurveyAnswer.first.created_at.beginning_of_day
    options[:stop_date]   ||= SurveyAnswer.last.created_at.end_of_day
    options[:start_age]   ||= 0
    options[:stop_age]    ||= 28

    options[:center] = user.center.id if !user.access?(:superadmin)
    puts "filter_params options: #{options.inspect}"
    if !options[:center].blank?
      center = Center.find(options[:center])
      options[:conditions] = ['center_id = ?', center.id]
    end
    options
  end
  
  def self.count_with_options(user, options = {})  # params are not safe, should only allow page/per_page
    self.with_options(user, options).count #(params)
  end  
  
  # filtrerer ikke på done, også kladder er med
  def self.with_options(user, options)
    o = self.filter_params(user, options)
    query = CsvSurveyAnswer.for_survey(o[:survey][:id]).
      between(o[:start_date], o[:stop_date]).
      aged_between(o[:start_age], o[:stop_age])

    # puts "options.: #{options.inspect}"
    # puts "options[:team]: #{options[:team].inspect}"
    options.delete(:team) if options[:team].blank?
    query = query.in_center(options[:center]) if !options[:center].blank?
    query = query.for_team(options[:team]) if !options[:team].blank?
    query
  end
  
  # def self.with_options(options)
  def headers
    %w{ssghafd ssghnavn safdnavn pid projekt pkoen palder pnation besvarelsesdato pfoedt}.join(';;')
  end

end