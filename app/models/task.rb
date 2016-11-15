class Task < ActiveRecord::Base
  belongs_to :export_file
  belongs_to :survey_answer
  belongs_to :letter
  belongs_to :journal
  belongs_to :group

  has_many :task_logs
  # belongs_to :task_logs

  after_initialize :init

  attr_accessible :status, :survey_answer, :param1, :journal_id, :letter_id, :group_id

  scope :for_group, lambda { |g| where(:group_id => g) }
  scope :with_status, lambda { |state| where("status IN (?)", state) }
  scope :between, ->(start, stop) { where(:created_at => start...stop) }
  scope :with_journal, -> { where('journal_id IS NOT NULL') }
  scope :of_type, lambda { |t| where('`type` = ?', t) }


  def init  # used by callback
    self.status = Task.todo_status
  end

  def todo?
    self.status == Task.todo_status
  end

  def todo!
    self.status = Task.todo_status
  end

  def in_progress?
    self.status == Task.in_progress_status
  end
  
  def failed?
    self.status == Task.failed_status
  end

  def failed!
    self.status = Task.failed_status
  end

  def approved?
    self.status == Task.approved_status
  end
  
  def approved!
    self.status = Task.approved_status
  end

  def completed?
    self.status == Task.completed_status
  end
  
  def completed!
    self.status = Task.completed_status
  end
  
  def archived!
    self.status = Task.archived_status
  end

  def no_action!
    self.status = 'No action'
  end

  def self.states
    {
      0 => 'To do',
      2 => 'In progress',
      3 => 'Approved',
      -1 => 'Failed',
      1 => 'Completed',
      99 => 'Archived'
    }
  end

  def self.todo_status
    self.states[0]
  end

  def self.approved_status
    self.states[3]
  end

  def self.completed_status
    self.states[1]
  end

  def self.in_progress_status
    self.states[2]
  end

  def self.failed_status
    self.states[-1]
  end

  def self.todo_state
    self.states[0]
  end
  
  def self.archived_status
    self.states[99]
  end

  # def self.approved_state
  #   self.states.revert['Approved']
  # end

  # def self.completed_state
  #   self.states.revert['Completed']
  # end

  # def self.in_progress_state
  #   self.states.revert['In progress']
  # end

  # def self.failed_state
  #   self.states.revert['Failed']
  # end

  def self.generate_survey_answers_to_csv
    logger.info "CSV save survey_answers: #{DateTime.now}"
    Task.find_each(:batch_size => 50, :conditions => 'survey_answer_id is not null and status = "To do"') do |task|
      sa = task.survey_answer
      sa.save_csv_survey_answer
      task.status = "Completed"
      task.save
      logger.info "CSV saved csv_survey_answer: #{sa.id}"   
    end
  end

  def create_survey_answer_export(survey_id, survey_answers)
    # Spawnling.new(:method => :fork) do
    # spawn_block do
#    Thread.new do
      logger.info "EXPORT create_survey_answer_export: survey: #{survey_id} #{survey_answers.size}"
      data = ExportAnswersHelper.new.export_survey_answers(survey_answers, survey_id)  # TODO: add csv generation on save_answer & change_answer
      logger.info "create_survey_answer_export: created data survey: #{survey_id} #{survey_answers.size}"
      # write data
      self.export_file = ExportFile.create(:data => data,
        # :type => 'text/csv; charset=utf-8; header=present',
        :filename => "eksport_svar_#{Time.now.to_date.to_s}_#{survey_id}" + ".csv",
        :content_type => "application/vnd.ms-excel")

      self.param1 = survey_id
      self.status = "Completed"
      logger.info "EXPORT set status completed"
      self.save
      logger.info "EXPORT saved status"
      # logger.info "create_survey_answer_export: finished!  survey: #{survey_id} #{survey_answers.size}"
#    end
  end

  def create_score_rapports_export(survey_id, csv_score_rapports)
    # spawn do
#    Thread.new do
      logger.info "EXPORT create_score_rapports_export: survey: #{survey_id} #{csv_score_rapports.size}"
      data = ExportAnswersHelper.new.score_rapports_to_csv(csv_score_rapports, survey_id)  # TODO: add csv generation on save_answer & change_answer
      logger.info "create_score_rapports_export: created data survey: #{survey_id} #{csv_score_rapports.size}"
      # write data
      self.export_file = ExportFile.create(:data => data,
        # :type => 'text/csv; charset=utf-8; header=present',
        :filename => "eksport_scorerapporter_#{Time.now.to_date.to_s}_#{survey_id}" + ".csv",
        :content_type => "application/vnd.ms-excel")

      self.param1 = survey_id
      self.status = "Completed"
      self.save
      logger.info "create_survey_answer_export: finished!  survey: #{survey_id} #{survey_answers.size}"
#    end
  end


  def create_wide_survey_answer_export(survey_ids, csv)
    logger.info "W_EXPORT create_survey_answer_export: survey: #{survey_ids.inspect}"
    # data = WideAnswersExport.new.export_survey_answers(survey_answers, survey_id)  # TODO: add csv generation on save_answer & change_answer
    logger.info "create_survey_answer_export: created data survey: #{survey_ids.inspect}"
    # write data
    ids = survey_ids.join("_")
    self.export_file = ExportFile.create(:data => csv,
      :filename => "eksport_#{Time.now.to_date.to_s}_#{ids}" + ".csv",
      :content_type => "application/vnd.ms-excel")

    self.param1 = ids
    self.status = "Completed"
    logger.info "W_EXPORT set status completed"
    self.save
    logger.info "W_EXPORT saved status"
  end

  # def create_sumscores_export(find_options)
  #   spawn do
  #     score_rapports = ScoreRapport.find_with_options(find_options)
  #     # write data
  #     t = Time.now
  #     self.export_file = ExportFile.create(:data => ZScoreGroup.to_xml(score_rapports.map {|sr| sr.score_results}).flatten,
  #       :filename => "sumscores_eksport" + Time.now.to_date.to_s + ".xml",
  #       :content_type => "text/xml")
  #     e = Time.now
  #     # puts "create_sumscores_export: #{e-t}"
  #     self.status = "Completed"
  #     self.save
  #   end
  # end

  # def create_csv_answer(survey_answer)
  #   spawn do
  #     survey_answer.create_csv_answer!
  #   end
  # end

  def create_csv_survey_answer(survey_answer)
    Spawnling.new(:method => :thread) do
      save_csv(survey_answer)
    end
  end
  
  def save_csv(survey_answer)
    survey_answer.save_csv_survey_answer
    score_rapport = ScoreRapport.find_by_survey_answer_id(survey_answer.id)
    score_rapport ||= survey_answer.generate_score_report(update = true)
    score_rapport.save_csv_score_rapport
  end

  def completed?
    self.status == "Completed"
  end

  # def completed!
  #   self.status = "Completed"
  #   self.save
  # end
  
end
