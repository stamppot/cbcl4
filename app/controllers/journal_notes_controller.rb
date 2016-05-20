class JournalNotesController < ApplicationController


	def edit
		@journal = Journal.find params[:id]
	end

	def update
		journal = Journal.find(params[:id])
		journal.notes = params[:notes]
		if journal.save
			redirect_to journal_path(journal)
		else
		    flash[:error] = 'Fejl, kunne ikke gemme noten.'
    		redirect_to journal_path(journal)
    	end
	end

end