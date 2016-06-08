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

  scope :between, ->(start, stop) { where(:created_at => start...stop) }
  scope :aged_between, ->(start, stop) { where(:age => start...stop) }
  scope :from_date, ->(start = DateTime.new(2005)) { where(:created_at => start...(Date.now)) }
  scope :to_date, ->(stop = DateTime.now) { where(:created_at  => (Date.now)...stop) }
  # scope :for_survey, lambda { |survey_id| { :conditions => { :survey_id => survey_id } } }
  scope :for_survey, ->(survey_id) { where(:survey_id => survey_id) }   # "csv_survey_answers.survey_id = ?", survey_id] } }
  scope :in_center, ->(center_id) { where(["csv_survey_answers.center_id = ?", center_id]) }
  scope :for_team, ->(team_id) { where(["csv_survey_answers.team_id = ?", team_id]) }
  scope :with_followup, lambda { |follow_up| follow_up && where(:follow_up => follow_up) }

  # scope :in_group, lambda { |options| { (!options[:center].blank? && {:conditions => ["csv_survey_answers.center_id = ?", team_id]}) || (!options[:team].blank? && {:conditions => ["csv_survey_answers.team_id = ?", team_id]}) } }

  attr_accessible :answer, :journal_id, :survey_answer_id, :center_id, :team_id, :survey_id, :journal_entry_id, :age, :sex, :created_at, :updated_at, :journal_info, :answer_count, :follow_up


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
    # puts "filter_params before start_age: #{options.inspect}"
    options[:start_age]   ||= 0
    options[:stop_age]    ||= 28

    options[:center] = user.center.id if !user.access?(:superadmin)
    # puts "filter_params options: #{options.inspect}"
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
    # puts "with_options: #{options.inspect}"
    o = self.filter_params(user, options)
    survey_id = o[:survey][:id]
    # puts "survey_id: #{survey_id} -- #{o[:survey][:id].inspect}"
    options.delete(:team) if options[:team].blank?

    query = if !options[:team].blank?
      # puts "with_options for_team: #{options[:team]}"
      CsvSurveyAnswer.between(o[:start_date], o[:stop_date])
        .aged_between(o[:age_start], o[:age_stop])
        .for_team(options[:team])
        .for_survey(survey_id)
      else
        # puts "with_options in_center: #{options[:center]}"
        CsvSurveyAnswer.between(o[:start_date], o[:stop_date])
        .aged_between(o[:age_start], o[:age_stop])
        .in_center(options[:center])
        .for_survey(survey_id)
      end

    # query = query.with_followup(options[:follow_up]) if options[:follow_up]

    # puts "query: #{query.to_sql.inspect}"
    # puts "options.: #{options.inspect}"
    # puts "options[:team]: #{options[:team].inspect}"
    # query = query.in_center(options[:center]) if !options[:center].blank?
    # query = query.for_team(options[:team]) if !options[:team].blank?

    query
  end
  
  # def self.with_options(options)
  def headers
    %w{ssghafd ssghnavn safdnavn pid projekt pkoen palder pnation besvarelsesdato pfoedt}.join(';;')
  end

  def update_follow_up
    je = self.journal_entry
    sa = self.survey_answer
    # make sure survey_answer.follow_up is correct
    if je && je.follow_up != sa.follow_up
      sa.follow_up = je.follow_up
      sa.save
    end

    self.follow_up = ( je || sa || {:follow_up => 0})[:follow_up]
    self.save
  end
end