class ErrorsController < ApplicationController


	def log
		@message = params[:message] || "Fejl"
		journal_entry_id = session[:journal_entry_id]
		logger.info "Error: #{@message}  Referrer: #{request.referer}   current_user: #{current_user.inspect}  journal_entry_id: #{journal_entry_id}"
		render 'errors/access_denied'
	end

end