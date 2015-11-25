module Api

	class AnswerReportsController < ApiController
	  
	  layout 'no_menu'
	  
	  # http://0.0.0.0:3000/api/answer_reports/show/13ccb7d0d0347440e7d62aa5a148f583/d25iQmh5Z3czcXBvVnpFRWFmcCtZaFpXNWkwMFllaGhBVkxkY3JSTVlKaGhaYlpycEhBRTJ6alZRRm9jClYzTlMK
	  def show
	    token = params[:token]
	    key = params[:api_key]
	    api_key = ApiKey.find_by_api_key(key)
	    login = eval(api_key.unlock token)
	
		# login_user = LoginUser.find_by_login_and_password(login["login"], login["password"])
		login_user = LoginUser.where(center_id: api_key.center_id, login: login["login"]).first
		
		params[:answers] = { login_user.journal_entry.id => 1}
		params[:journal_id] = login_user.journal_entry.journal_id

	    puts "login: #{login.inspect}"
	    
	    score_report = ScoreReportPresenter.new.build(params[:answers], params[:journal_id])
	    puts "score_report: #{score_report.inspect}"
	    @journal = score_report.journal
	    @titles  = score_report.titles #.map {|t| t.gsub("nn", "<br/>")}
	    @groups  = score_report.groups
	    @scales  = score_report.scales
	    @group_titles = score_report.group_titles
	
	    @answer_texts = []
	    params[:answers].keys.each do |journal_id|
	      journal_entry = JournalEntry.and_survey_answer.find(journal_id)
	      survey_answer = SurveyAnswer.and_answer_cells.find(journal_entry.survey_answer_id)
	      survey = Survey.and_questions.find(survey_answer.survey_id)
	      questions = survey.merge_report_answer(survey_answer)
	      puts "created_at: #{survey_answer.created_at}"
	      @answer_texts << {:questions => questions, :survey => survey, :answer_date => survey_answer.created_at}
	    end
	    
	    render :json => { :survey => score_report.titles.last, :data => score_report.groups } #  @answer_texts
	    # @page_title = "CBCL - Udvidet Svarrapport: " << @journal.title
	  end 
	end
end