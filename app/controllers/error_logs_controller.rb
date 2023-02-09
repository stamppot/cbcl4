class ErrorLogsController < ApplicationController

	def index
		options = { :include => :group, :page => params[:page], :per_page => 50, :column => params[:column], 
		    	    :order => params[:order] }  # not used yet

		@error_logs = ErrorLog.all.order(id: :desc)

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @error_logs }
			format.json { render :json => @error_logs }
		end
	end
end
