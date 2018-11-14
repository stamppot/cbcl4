class JournalStatsController < ApplicationController
	
	def per_page
    Journal.per_page #REGISTRY[:journals_per_page]
 	end
  
	def index
		@journal_stats = JournalStat.surveys_per_center_by_state
		# options = { :include => :parent, :page => params[:page], :per_page => per_page }
  	@answered_by_login_users = JournalEntry.where(['state = ? and answered_at > ?', 6, DateTime.new(2011,01,15)]).count
		@answered_by_personnel = JournalEntry.where(['state = ? and answered_at > ?', 5, DateTime.new(2011,01,15)]).count
  	@answered_by_login_users_total = JournalEntry.where(['state = ?', 6]).count
		@answered_by_personnel_total = JournalEntry.where(['state = ?', 5]).count
	  # @groups = current_user.journals(options) || [] # TODO: Move to configuration option
	end
	
	def show
		options = { :page => params[:page], :per_page => per_page }
		@center = Center.find(params[:id])
  	@answered_by_login_users = JournalEntry.where(['answered_at > ?', DateTime.new(2011,01,15)]).in_center(params[:id]).answered_by_login_user.count
		@answered_by_personnel = JournalEntry.where(['answered_at > ?', DateTime.new(2011,01,15)]).in_center(params[:id]).answered.count
  	@answered_by_login_users_total = JournalEntry.in_center(params[:id]).answered_by_login_user.count
		@answered_by_personnel_total = JournalEntry.in_center(params[:id]).answered.count
		# options.merge!()
	  @groups = Journal.where(['center_id = ?', params[:id]]).paginate(options) || [] # TODO: Move to configuration option
	end
	
end