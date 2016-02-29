# encoding: utf-8

# require 'ar-extensions/adapters/mysql'
# require 'ar-extensions/import/mysql'
# require 'facets'
require 'hashery'


class SurveyAnswer < ActiveRecord::Base
  belongs_to :survey
  belongs_to :journal
  belongs_to :center
  belongs_to :team
  has_many :answers, -> { includes :answer_cells }, dependent: :destroy
  #belongs_to :journal_entry
  has_one :journal_entry
  has_one :score_rapport, -> { includes :score_results }, dependent: :destroy #, :include => [ :score_results ]
  has_one :csv_survey_answer, dependent: :destroy
  has_one :csv_score_rapport, dependent: :destroy

  attr_accessible :survey_id, :age, :sex, :journal, :surveytype, :nationality, :journal_entry, :center_id, :survey, :journal_entry_id, :journal_id, :follow_up
  
  scope :finished, -> { where('done = ?', true) }
  scope :in_center, lambda { |center_id| { :conditions => ['center_id = ?', center_id] } }

  scope :order_by, lambda { |column| { :order => column } }
  scope :and_answer_cells, -> { includes ({ answers: :answer_cells }) }
  scope :and_questions, -> { includes( { survey: :questions }) }
  scope :between, lambda { |start, stop| { :conditions => { :created_at  => start..stop } } }
  scope :aged_between, lambda { |start, stop| { :conditions => { :age  => start..stop } } }
  scope :from_date, lambda { |start| { :conditions => { :created_at  => start..(Date.now) } } }
  scope :to_date, lambda { |stop| { :conditions => { :created_at  => (Date.now)..stop } } }
  scope :for_surveys, lambda { |survey_ids| { :conditions => { :survey_id => survey_ids } } }
  scope :for_survey, lambda { |survey_id| { :conditions => ["survey_answers.survey_id = ?", survey_id] } }
  scope :with_journals, -> { joins("INNER JOIN `journal_entries` ON `journal_entries`.journal_id = `journal_entries`.survey_answer_id").includes({:journal_entry => :journal}) }
  scope :for_entries, lambda { |entry_ids| where({ :journal_entry_id => entry_ids }) } # ["survey_answers.journal_entry_id IN (?)", 
  scope :for_team, ->(team_id) { where(["survey_answers.team_id = ?", team_id]) }
  scope :with_followup, lambda { |follow_up| follow_up && where(:follow_up => follow_up) }

  def answered_by_role
    return Role.get(self.answered_by)
  end

  def age_when_answered
     ( (self.created_at.to_datetime - self.journal.birthdate).to_i / 365.25).floor if self.journal
  end
   
  def age_now
    ( (DateTime.now - self.journal.birthdate).to_i / 365.25).floor if self.journal
  end
  
  def update_age!
    age = age_when_answered
    if !age
      logger.info "SurveyAnswer #{self.id} has no journal (deleted): #{self.inspect}"
      return
    end 
    csv_survey_answer.age = age
    csv_score_rapport.age = age
    self.save
    csv_survey_answer.save
    csv_score_rapport.save
  end

  def self.count_with_options(user, options = {})  # params are not safe, should only allow page/per_page
    self.with_options(user, options).count #(params)
  end  
  
  # filtrerer ikke på done, også kladder er med
  def self.with_options(user, options)
    puts "SurveyAnswer.with_options: #{options.inspect}"
    o = self.filter_params(user, options)
    survey_ids = o[:surveys]
    puts "survey_ids: #{survey_ids} -- #{o[:surveys].inspect}"
    options.delete(:team) if options[:team].blank?

    query = if !options[:team].blank?
      puts "with_options for_team: #{options[:team]}"
      SurveyAnswer.between(o[:start_date], o[:stop_date])
        .aged_between(o[:age_start], o[:age_stop])
        .for_team(options[:team])
        .for_surveys(survey_ids)
      else
        puts "with_options in_center: #{options[:center]}"
        SurveyAnswer.between(o[:start_date], o[:stop_date])
        .aged_between(o[:age_start], o[:age_stop])
        .in_center(options[:center])
        .for_surveys(survey_ids)
      end

    query = query.with_followup(options[:follow_up]) if options[:follow_up]

    puts "query: #{query.to_sql.inspect}"
    puts "options.: #{options.inspect}"
    puts "options[:team]: #{options[:team].inspect}"
    # query = query.in_center(options[:center]) if !options[:center].blank?
    # query = query.for_team(options[:team]) if !options[:team].blank?
    query
  end

  def self.save_manual(params)
    id = params.delete("id")
    journal_entry ||= JournalEntry.find(id)
    center = journal_entry.journal.center
    subscription = center.subscriptions.detect { |sub| sub.survey_id == journal_entry.survey_id }
    survey = Survey.and_questions.find(journal_entry.survey_id)
    survey_answer = journal_entry.make_survey_answer
    ok = survey_answer.save_final(params)
    journal_entry.answered! 
  end

  def save_draft(params)
    # t = Thread.new do
      survey_answer = journal_entry.survey_answer
      survey_answer.done = false
      survey_answer.journal_entry_id ||= journal_entry.id
      survey_answer.follow_up = journal_entry.follow_up
      survey_answer.set_answered_by(params)
      survey_answer.save_answers(params)
      survey_answer.center_id ||= journal_entry.journal.center_id
      survey_answer.save
    # end
    # t.join
  end
  

  def save_final(params)
    set_answered_by(params)
    self.done = true
    self.save   # must save here, otherwise partial answers cannot be saved becoz of lack of survey_answer.id
    self.save_answers(params) #if save_the_answers
    self.journal_entry.answer_info = self.info.values.join(";");
    # self.answers.each { |a| a.update_ratings_count }
    Answer.transaction do
      answers.each {|a| a.save!}
    end
      # survey_answer.add_missing_cells unless current_user.login_user # 11-01-10 not necessary with ratings_count
    # Spawnling.new(:method => :fork) do
    score_rapport = self.generate_score_report(update = true) # generate score report
    score_rapport.save_csv_score_rapport
    self.save_csv_survey_answer
    self.save
  end
  
	def set_answered_by(params = {})
    # if answered by other, save the textfield instead    # "answer"=>{"person_other"=>"fester", "person"=>"15"}
    if params[:answer] && (other = params[:answer][:person_other]) && !other.blank? && (other.to_i == Role.get(:other).id)
      self.answered_by = other
    end
    self.journal_entry_id = self.journal_entry.id if journal_entry_id == 0
    self.answered_by = params[:answer] && params[:answer][:person] || ""
	end

	# doesn't work?!  # 14-11-2011
	def all_answered?
		self.no_unanswered == 0
	end

  def cell_values(prefix = nil)
    prefix ||= self.survey.prefix
    a = Dictionary.new
    self.answers.each { |answer| a.merge!(answer.cell_values(prefix)) }
    a.order_by
  end
  
    # info on journal in array of hashes
  def info
    j = self.journal
    # settings = CenterSetting.find_by_center_id_and_name(self.center_id, "use_as_code_column")
    c = Dictionary.new # ActiveSupport::OrderedHash.new
    c["ssghafd"] = j.group.group_code
    c["ssghnavn"] = self.center.title
    c["safdnavn"] = j.group.title
    c["pid"] = j.code #settings && eval("self.#{settings.value}") || j.code
    c["projekt"] = j.alt_id || ""
    c["pkoen"] = j.sex
    c["palder"] = self.age_when_answered if self.age_when_answered  # alder på besvarelsesdatoen
    c["pnation"] = j.nationality
    c["besvarelsesdato"] = self.created_at.strftime("%d-%m-%Y")
    c["pfoedt"] = j.birthdate.strftime("%d-%m-%Y")  # TODO: translate month to danish
    c
  end
  
  # cascading does not work over multiple levels, ie. answer_cells are not deleted
  def delete
    # better solution: iterate through answers, do cascading delete
    answers = self.answers
    answers.each { |answer| Answer.find(answer.id).destroy }  # deletes answers and answer cells
    SurveyAnswer.destroy self.id
  end
  
  def sort_answers
    self.answers.sort
  end

  def max_answer
    max = self.answers.where(id: problem_item_answer_id).first
  end

  def problem_item_answer_id
    query = "select a.id as answer_id from answers a
      inner join question_cells qc on qc.question_id = a.question_id
      where a.survey_answer_id = #{self.id} and qc.problem_item = 1
      limit 1"
    answer = ActiveRecord::Base.connection.execute(query).each(:as => :hash).first
    if answer
      answer["answer_id"]
    else 
      answer = self.answers.max {|q,p| q.count_items <=> p.count_items }  # last is for when answer is not created
      answer && answer.id || 0
    end
  end

  def no_answered_problem_items
    # count values in largest answer
    answer_id = self.problem_item_answer_id || 0 # answers.detect {|answer| answer.question_id == score_item.question_id }
    query = "select count(distinct(ac.id)) as answered_problem_items from answer_cells ac
      inner join answers a on a.id = ac.answer_id
      inner join questions q on q.id = a.question_id
      inner join question_cells qc on qc.question_id = q.id
      where answer_id = #{answer_id} and qc.problem_item = 1 and ac.value != 9
      order by qc.id"

    answered_problem_items = ActiveRecord::Base.connection.execute(query).each(:as => :hash).first
    # puts "#{answered_problem_items.inspect}"
    answered_problem_items && answered_problem_items["answered_problem_items"] || 0
  end

  def no_unanswered
    # count values in largest answer
    answer = self.max_answer
    answered = self.no_answered_problem_items
    unanswered = if answer 
      (answer.question.ratings_count - answered)
    else
      self.survey.question_with_most_items.ratings_count
    end
  end

  def answered_percentage
    answer = self.max_answer
    answered = self.no_answered_problem_items
    answered_percentage = answer && (answered*100) / answer.question.ratings_count || 0
  end

  def add_missing_cells
    self.max_answer.add_missing_cells
  end
  
  def sex_text
    PersonInfo.sexes.invert[self[:sex]]
  end
  
  # get all scores related to this survey answer.
  def scores
    Survey.find(survey_id, :include => { :scores => :score_items } ).scores
  end

  def update_score_report(update = false)
    rapport = ScoreRapport.find_by_survey_answer_id(self.id, :include => {:survey_answer => :journal})
    args = { :survey_name => self.survey.get_title,
                  :survey => self.survey,
              :unanswered => self.no_unanswered,
       :answer_percentage => self.answered_percentage,
              :short_name => self.survey.category,
               :age_group => self.survey.age,
              :created_at => self.created_at,  # set to date of survey_answer
               :center_id => self.center_id,
        :survey_answer_id => self.id
            }
    if self.journal
      args[:age] = self.age_when_answered
      args[:gender] = self.journal.sex
    end

    if rapport
      args[:age] ||= rapport.age
      args[:gender] ||= rapport.gender
      rapport.update_attributes(args) if update && !rapport.new_record?
    else
      generate_score_report
    end
  end

  def generate_score_report(update = false)
    rapport = ScoreRapport.find_by_survey_answer_id(self.id, :include => {:survey_answer => :journal})
    args = { :survey_name => self.survey.get_title,
                  :survey => self.survey,
              :unanswered => self.no_unanswered,
       :answer_percentage => self.answered_percentage,
              :short_name => self.survey.category,
               :age_group => self.survey.age,
              :created_at => self.created_at,  # set to date of survey_answer
               :center_id => self.center_id,
        :survey_answer_id => self.id,
               :follow_up => (self.journal_entry && self.journal_entry.follow_up || 0)
            }
    if self.journal
      args[:age] = self.age_when_answered
      args[:gender] = self.journal.sex
    end

    rapport = ScoreRapport.create(args) unless rapport
    rapport.update_attributes(args) if update && !rapport.new_record?
    
    logger.info "Rapport gender: #{rapport.gender} #{self.journal.title}"
    
    scores = self.survey.scores
    scores.each do |score|
      score_result = ScoreResult.where('score_id = ? AND score_rapport_id = ?', score.id, rapport.id).first
      
      # everything is calculated already
      if !update && score_result && score_result.valid_percentage && !score_result.title && !score_result.scale && !score_result.result && !score_result.percentile && !score_result.percentile_98 && 
        !score_result.percentile_95 && !score_result.deviation 
        next
      else
        result, percentile, mean, missing, hits, age_group = score.calculate(self)
        score_ref = score.find_score_ref(self.age, self.sex)
        puts "CALC SCORE: #{result} #{percentile}  scoreref: #{score_ref.inspect}"

        # ADHD score (id: 57 has no items)
        missing_percentage = if score.items_count.blank? or score.items_count == 0
          99.99
        else
          ((missing.to_f / score.items_count.to_f) * 100.0).round(2)
        end          
        # puts "sc: #{score.title} items: #{score.items_count} sr: #{score_result.id} miss: #{missing}  score: #{score.id} sa_id: #{self.id}"
        # puts "perc: #{missing_percentage} "
        
        args = { 
          :title => score.title, 
          :score_id => score.id, 
          :scale => score.scale, 
          :survey => self.survey,
          :result => result, 
          :percentile_98 => (percentile == :percentile_98),
          :percentile_95 => (percentile == :percentile_95),
          :deviation => (percentile == :deviation),
          :score_rapport => rapport, 
          :mean => mean,
          :position => score.position,
          :score_scale_id => score.score_scale_id,
          :hits => hits,
          :missing => missing,
          :missing_percentage => missing_percentage, 
          :valid_percentage => (missing_percentage <= 10.0)
        }
        
        if score_result
          score_result.update_attributes(args)
        else
          score_result = ScoreResult.create(args)
        end
      end
      rapport.short_name = score.short_name
    end
    rapport.save
    rapport.save_csv_score_rapport
    rapport
  end
        
  # print all values iteratively
  def print
    output = "Survey Answer: #{self.survey.get_title}<br>"
    answers.each { |answer| output << answer.print }
    return output
  end
  
  def save_answers(params)
    params.each do |key, cells|
      if key =~ /Q\d+/ && (cells.nil? || (cells.size == 1 && cells.has_key?("id")))
          params.delete(key)
      end
    end
    params.each_key { |question| params.delete(question) if params[question].empty? }
    # logger.info "survey: #{survey.id}  valid_values: #{survey.valid_values.inspect}"
    the_valid_values = survey.valid_values # TODO: cache #cache_fetch("survey_valid_values_#{self.survey_id}") { self.survey.valid_values }
    insert_cells = []
    update_cells = []
  
    puts "save_answers:: params: #{params.inspect}"

    params.each do |key, q_cells|   # one question at a time
      puts "key: #{key}  q_cells: #{q_cells.inspect}"
      next unless key.include? "Q"
      q_id = q_cells.delete("id")
      q_number = key.split("Q").last
      q_number = q_number.to_i
      # puts "q_id: #{q_id}, q_no: #{q_number}"

      an_answer = self.answers.find_by_question_id(q_id)
      an_answer ||= self.answers.build(:survey_answer_id => self.id, :question_id => q_id, :number => q_number)
      an_answer.valid?
      # puts "#{an_answer.errors.inspect}"
      an_answer.save

      new_cells ||= {}
      q_cells.each do |cell, value|
        # puts "cell: #{cell.inspect}  value: #{value.inspect}"
        if cell =~ /q(\d+)_(\d+)_(\d+)/   # match col, row
          q = "Q#{$1}"
          a_cell = {:answer_id => an_answer.id, :row => $2.to_i, :col => $3.to_i, :value => value, :number => q_number}
          if answer_cell = an_answer.exists?(a_cell[:row], a_cell[:col]) # update
            changed_val = answer_cell.change_value(value, the_valid_values[q][cell])
            # puts "answer_cell exists: @#{answer_cell.inspect}  a_cell: #{a_cell.inspect} changed_val: #{changed_val.inspect}"
            update_cells << [answer_cell.id,  answer_cell.value, answer_cell.value_text] if changed_val
          else
            new_cells[cell] = a_cell  # insert
          end
        end
      end
      insert_cells += an_answer.create_cells_optimized(new_cells, the_valid_values[key])
      new_cells.clear
    end
    # columns = [:answer_id, :row, :col, :item, :answertype, :value, :rating, :text, :value_text, :cell_type]
    columns = [:answer_id, :row, :col, :item, :value, :rating, :text, :value_text, :cell_type]
    t = Time.now; new_cells_no = AnswerCell.import(columns, insert_cells, :on_duplicate_key_update => [:value, :value_text]); e = Time.now
    # puts "MASS IMPORT ANSWER CELLS (#{new_cells_no.num_inserts}): #{e-t}"

    t = Time.now; updated_cells_no = AnswerCell.import([:id, :value, :value_text], update_cells, :on_duplicate_key_update => [:value, :value_text]); e = Time.now
    # puts "updated cells: #{update_cells.inspect}"
    # puts "MASS IMPORT (update) ANSWER CELLS (#{updated_cells_no.num_inserts}): #{e-t}"

    self.answers.each { |a| a.update_ratings_count }
    return self
  end
    
  # used by draft_data to get positions of values
  def setup_draft_values
    self.answers.map { |answer| answer.setup_draft_values }.flatten
  end
  
  def variable_values
    variables = self.survey.variables.map {|v| v.var.to_sym}
    values = self.cell_values
    result = variables.inject(Dictionary.new) do |col,var|
      col[var] = values[var] || "#NULL!"
      col
    end
    
  end
  
  def save_csv_survey_answer
    vals = variable_values
    options = {
      :answer => vals.values.join(';;'), 
      :journal_id => self.journal_id,
      :survey_answer_id => self.id,
      :center_id => self.center_id,
      :team_id => self.team_id,
      :survey_id => self.survey_id,
      :journal_entry_id => self.journal_entry_id,
      :age => self.age_when_answered,
      :sex => self.journal.sex,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :journal_info => to_danish(self.info.values.join(';;')),
      :answer_count => vals.values.size
    }
    
    csa = self.csv_survey_answer
    if csa
      csa.update_attributes(options)
      update_info
    else
      csa = CsvSurveyAnswer.create(options)
    end
  end

  def update_info
    return if journal.nil?
    alt_id = journal.alt_id
    return if alt_id.blank?
    self.alt_id = alt_id
    self.save

    csa = CsvSurveyAnswer.find_by_survey_answer_id(self.id)
    if csa.nil?
      puts "CSA for survey_answer #{self.id} not found"
      return
    end
    csa.journal_info = to_danish(self.info.values.join(';;'))
    csa.save
    puts "fixed #{id}"
  end
  
  def to_danish(str)
    str.gsub("Ã¸", "ø").gsub("Ã¦", "æ").gsub("Ã…", "Å")
  end
    
  def self.create_csv_answers!
    CSVHelper.new.generate_all_csv_answers
  end
  
  # finished survey answers, based on accessible journals
  def self.filter_finished(user, options = {})  # params are not safe, should only allow page/per_page
    page       = options[:page] ||= 1
    per_page   = options[:per_page] ||= 100000
    o = self.filter_params(user, options)
    params = options[:center] && {:conditions => ['center_id = ?', o[:center].id]} || {}
    SurveyAnswer.for_surveys(o[:surveys]).finished.between(o[:start_date], o[:stop_date]).aged_between(o[:start_age], o[:stop_age]).paginate(params.merge(:page => page, :per_page => per_page))
  end

  def self.filter_finished_count(user, options = {})  # params are not safe, should only allow page/per_page
    o = self.filter_params(user, options)
    params = options[:center] && {:conditions => ['center_id = ?', o[:center].is_a?(Center) ? o[:center].id : o[:center]]} || {}
    SurveyAnswer.for_surveys(o[:surveys]).finished.between(o[:start_date], o[:stop_date]).aged_between(o[:start_age], o[:stop_age]).count(params)
  end

  def self.filter_params(user, options = {})
    options[:start_date]  ||= SurveyAnswer.first.created_at
    options[:stop_date]   ||= SurveyAnswer.last.created_at
    options[:start_age]   ||= 0
    options[:stop_age]    ||= 28
    # options[:surveys]     ||= Survey.all.map {|s| s.id}
    if !options[:center].blank?
      center = Center.find(options[:center])
      # options[:journal_ids] = center.journal_ids if center && !options[:journal_ids]
    end
    # options[:journal_ids] ||= user.journal_ids
    options
  end

  # def to_xml(options = {})
  #   if options[:builder]
  #     build_xml(options[:builder])
  #   else
  #     xml = Builder::XmlMarkup.new
  #     xml.__send__(:survey_answer, {:created => self.created_at}) do
  #       xml.answers do
  #         # self.rapports.map(&:score_rapports).each do |rapport|
  #         self.cell_vals.each do |answer_vals|
  #           xml.__send__(:answer, {:number => answer_vals[:number]}) do
  #             xml.cells do
  #               answer_vals[:cells].each do |cell_h|
  #                 attrs = {:v => cell_h[:v], :var => cell_h[:var], :type => cell_h[:type] }
  #                 xml.__send__(:cell, attrs)
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
  
end
