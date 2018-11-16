class InfoAnswerReportsController < ApplicationController
  layout 'survey_print', :only => [:print]

  def show
    if params[:answers].nil?
      journal_id = params[:journal_id].to_i
      redirect_to journals_path(journal_id) and return 
    end
    # extract infoskema from params list
    info_answers = params[:answers].select do |id| 
    	entry = JournalEntry.find(id)
    	puts "is info? #{entry.survey_id}"
    	entry.survey_id == 10 || entry.survey_id == 11 || entry.survey_id == 210
    end
    @answer_values = nil
    if info_answers.any?
    	params[:answers].delete(info_answers.keys.first)  # can only be one info_skema
	  	entry = JournalEntry.find(info_answers.keys.first)
  		@answer_values = entry.survey_answer.answer_values
  		@info_survey = entry.survey
    end

    score_report = ScoreReportPresenter.new.build(params[:answers], params[:journal_id])
    puts "score_report: #{score_report.inspect}"
    @journal = score_report.journal
    @titles  = score_report.titles #.map {|t| t.gsub("nn", "<br/>")}
    @groups  = score_report.groups
    @scales  = score_report.scales
    @group_titles = score_report.group_titles

    @answer_texts = []
    params[:answers].select {|key,val| val.to_i == 1}.keys.each do |journal_id|
      journal_entry = JournalEntry.and_survey_answer.find(journal_id)
      survey_answer = SurveyAnswer.and_answer_cells.find(journal_entry.survey_answer_id)
      survey = Survey.and_questions.find(survey_answer.survey_id)
      questions = survey.merge_report_answer(survey_answer)
      puts "created_at: #{survey_answer.created_at}"
      @answer_texts << {:questions => questions, :survey => survey, :answer_date => survey_answer.created_at}
    end

    puts "answer_texts: #{@answer_texts.inspect}"    
    @page_title = "CBCL - Udvidet Svarrapport: " << @journal.title

  end
  
end
