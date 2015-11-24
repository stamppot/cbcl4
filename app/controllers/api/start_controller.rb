require 'json'

module Api

  # Test Testesen3 VzR6Q1Uwa0FPcGRtSHZYOWEybXhCeHA5bDZ5ek1Ha2x4QThrSUlmNTNZZGtZbHlZNWRNYUpOTzlrbTF2CkZmSDIK
    class StartController < ApiController
    
    	# protect_from_forgery
     	# before_filter :cors_preflight_check
     	# after_filter :cors_set_access_control_headers
    
    
    	def start
    	  logger.info "api/start check_access: #{params.inspect}"
        token = params[:token]
    
    		puts "current_user: #{current_user.inspect}"
    		login_user = LoginUser.find(current_user.id)
        @journal_entry = login_user.journal_entry
        puts "entry: #{@journal_entry.inspect}"
        session[:journal_entry] = @journal_entry.id
        session[:journal_id] = @journal_entry.journal_id
        session[:api_key] = params[:api_key]
        session[:token] = token
        # @center = @journal_entry.journal.center
        redirect_to login_path and return if @journal_entry.nil?
        puts "redirect to /start"
        redirect_to survey_start_path(params[:api_key], token)
      end
    end
end