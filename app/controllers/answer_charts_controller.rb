class AnswerChartsController < ApplicationController
  
  layout 'no_menu'
  
  def show
    if params[:answers].nil?
      journal_id = params[:journal_id].to_i
      redirect_to journals(journal_id) and return 
    end
    # score_report = ScoreReportPresenter.new.build(params[:answers], params[:journal_id])
    score_chart = ScoreChartPresenter.new.build(params[:answers], params[:journal_id])
    puts "score_chart: #{score_chart.inspect}"
    @journal = score_chart.journal
    @titles  = score_chart.titles #.map {|t| t.gsub("nn", "<br/>")}
    @groups  = score_chart.groups
    @scales  = score_chart.scales
    @group_titles = score_chart.group_titles

    @answer_texts = []
    params[:answers].select {|k,v| v == "1"}.keys.each do |journal_id|
      journal_entry = JournalEntry.and_survey_answer.find(journal_id)
      survey_answer = SurveyAnswer.and_answer_cells.find(journal_entry.survey_answer_id)
      survey = Survey.and_questions.find(survey_answer.survey_id)
      questions = survey.merge_report_answer(survey_answer)
      puts "created_at: #{survey_answer.created_at}"
      @answer_texts << {:questions => questions, :survey => survey, :answer_date => survey_answer.created_at}
    end
    
    @page_title = "CBCL - Udvidet Svarrapport: " << @journal.title
    # render 'show'
  end 
end
