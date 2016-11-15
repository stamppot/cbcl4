class CsvSurveyAnswerTask < Task
  belongs_to :export_file
  belongs_to :survey_answer

  # attr_accessible :status

  # def self.create_csv_survey_answer_task(survey_answer_id)
  #   Task.create(:survey_answer_id => survey_answer_id, :status => "To do")
  # end

  def self.run_tasks
    self.generate_survey_answers_to_csv
  end

  def self.generate_survey_answers_to_csv
    logger.info "CSV save survey_answers: #{DateTime.now}"
    Task.find_each(:batch_size => 50, :conditions => "survey_answer_id is not null and status = '#{Task.todo_status}'") do |task|
      sa = task.survey_answer
      sa.save_csv_survey_answer
      task.update_attribute("status", "Completed")
      task.save
      logger.info "CSV saved csv_survey_answer: #{sa.id}"   
      puts "CSV saved csv_survey_answer: #{sa.id}"   
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
      self.update_attribute("status", "Completed")
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

  # def completed?
  #   self.status == "Completed"
  # end

  # def completed!
  #   self.status = "Completed"
  #   self.save
  # end
  
end