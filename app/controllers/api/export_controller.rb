require 'json'

module Api

  # Test Testesen3 VzR6Q1Uwa0FPcGRtSHZYOWEybXhCeHA5bDZ5ek1Ha2x4QThrSUlmNTNZZGtZbHlZNWRNYUpOTzlrbTF2CkZmSDIK
  class ExportController < ApiController
    
    	# protect_from_forgery
     	# before_filter :cors_preflight_check
     	# after_filter :cors_set_access_control_headers
    
    
    def csv_raw
      logger.info "api/export/csv_raw check_access: #{params.inspect}"
      token = params[:token]
    
    	puts "current_user: #{current_user.inspect}"
    	login_user = LoginUser.find(current_user.id)
      journal_entry = login_user.journal_entry
      puts "entry: #{journal_entry.inspect}"

      survey_answer = journal_entry.survey_answer

      if !survey_answer
        s_title = journal_entry.survey.title
        j = journal_entry.journal.title
        render :json => { :error => "No survey answer found", :survey => s_title, :journal => j } and return
      end 

      w = WideAnswersExport.new
      csv = w.csv_export_single_answer(survey_answer) 
      render :json => { :csv => csv }
    end
  end
end