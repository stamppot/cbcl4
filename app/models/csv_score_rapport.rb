require 'csv'

class CsvScoreRapport < ActiveRecord::Base
  belongs_to :journal
  belongs_to :survey_answer
  
  scope :for_survey, -> (survey_id) { where(["csv_score_rapports.survey_id = ?", survey_id]) }
  scope :in_center, -> (center_id) { where(["csv_score_rapports.center_id = ?", center_id]) }
  scope :for_team, -> (team_id) { where(["csv_score_rapports.team_id = ?", team_id]) }
  scope :between, -> (start, stop) { where(:created_at  => (start..stop)) }
  scope :aged_between, -> (start, stop) { where(:age  => (start..stop)) }

  attr_accessible :answer, :variables, :journal_id, :survey_answer_id, :team_id, :center_id, :survey_id, :age, :answer_percentage, :created_at, :updated_at, :sex
  
  def self.with_options(user, options)
    o = self.filter_params(user, options)
    puts "with_options: #{o.inspect}"
    query = CsvScoreRapport.for_survey(o[:survey][:id]).
      between(o[:start_date], o[:stop_date]).
      aged_between(o[:start_age], o[:stop_age])
      
    query = query.in_center(options[:center]) if !options[:center].blank?
    query = query.for_team(options[:team]) if !options[:team].blank?
    query
  end
  
  def self.filter_params(user, options = {})
    options[:start_date]  ||= ScoreRapport.first.created_at
    options[:stop_date]   ||= ScoreRapport.last.created_at
    options[:start_age]   ||= 0
    options[:stop_age]    ||= 28

    options[:center] = user.center if !user.access?(:superadmin)
    if !options[:center].blank?
      center = Center.find(options[:center])
      options[:conditions] = ['center_id = ?', center.id]
    end

    options
  end
  
  private

  def self.date(h)
    Date.new(h[:year].to_i, h[:month].to_i, h[:day].to_i)
  end
end