class JournalEntriesController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  before_filter :check_access

  # We force users to use POST on the state changing actions.
  # verify :method       => "post",
  #        :only         => [ :remove, :remove_answer, :destroy_login ]

  def show
    journal_entry = JournalEntry.includes(:journal).find(params[:id])
    session[:journal_entry] = journal_entry.id
    session[:journal_id] = journal_entry.journal_id
    cookies[:journal_entry] = journal_entry.id
    cookies[:journal_id] = journal_entry.journal_id
    # logger.info "Setting session[:journal_entry] to #{journal_entry.id} for #{journal_entry.journal.title}"
    
    if params[:fast]
      redirect_to survey_show_fast_path(journal_entry.id) and return # caching disabled, so not .survey_id
    else
      redirect_to survey_path(journal_entry.survey_id) and return # using caching!
    end
  end

  def show_answer
    # puts "Show Answer JournalEntriesController #{params.inspect}"
    journal_entry = JournalEntry.includes(:journal).find(params[:id])
    session[:journal_entry] = params[:id]
    session[:journal_id] = journal_entry.journal_id
    redirect_to survey_answer_path(journal_entry.survey_id)
  end

  # deletes and updates page with ajax call
  def remove
    elem = "entry" << params[:id]
    entry = JournalEntry.find(params[:id])
    entry.destroy

    render :json => {:ok => true}
  end

  # remove an answer and the associated login-user. Remove entries from the journal_entry
  # TODO: nu sletter den svaret. Skal svaret ikke gemmes i anonym form, dvs. det skal ikke slettes, kun fra journalen?
  def remove_answer
    elem = "entry_answer" << params[:id]
    entry = JournalEntry.find(params[:id])
    # remove any score report created
    # delete all answers and answer cells, delete login for journal_entry
    entry.destroy if !entry.nil?

    if entry && entry.survey_answer
      sc = ScoreRapport.find_by_survey_answer_id(entry.survey_answer.id)
      sc.destroy unless sc.nil?
    end
    
    render :json => {:ok => true} and return
    # if entry.destroy
    #   render :update do |page|
    #     page.visual_effect :slide_up, elem
    #     page.remove elem
    #   end
    # end
  # rescue ActiveRecordError
    # render :json => {:ok => true} and return
  end

  def edit # edit follow_up
    @journal_entry = JournalEntry.find(params[:id])
    @follow_ups
    @follow_ups = FollowUp.get
  end

  def update
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entry.follow_up = params[:journal_entry][:follow_up]
    @journal_entry.save
    redirect_to journal_path(@journal_entry.journal)
  end

  def edit_notes
    @journal_entry = JournalEntry.find(params[:id])
    @notes
  end

  def update_notes
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entry.notes = params[:journal_entry][:notes]
    @journal_entry.save
    redirect_to journal_path(@journal_entry.journal)
  end

  def edit_chain
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entries = @journal_entry.journal.not_answered_entries.select do |je| 
      je != @journal_entry &&
      je.follow_up == @journal_entry.follow_up &&
      je.survey.surveytype == @journal_entry.survey.surveytype
    end
  end

  def update_chain
    journal_entry = JournalEntry.find(params[:id])
    dest = JournalEntry.find(params[:chain])
    flash[:notice] = "Intet valg" if !dest
    if dest
      first = journal_entry.survey_id
      couple = {first => dest.survey_id}
      JournalEntryService.new.connect_entries([journal_entry, dest], couple, true)
      flash[:notice] = "Besvarelser er kædet sammen"
    end
    redirect_to journal_path(journal_entry.journal)
  end

  protected
  
  def check_access
    if current_user and ((current_user.access?(:all_users) || current_user.access?(:login_user))) and params[:id]
      # j_id = JournalEntry.find(params[:id]).journal_id
      access = current_user.has_journal_entry? params[:id]
      # puts "journal_entries: #{params[:action]} access? #{access}"
      # access
      # # access = journal_ids.include? j_id
    end  # cookie and session are not set before after this check, so it's old/wrong data
    logger.info "check_access: params: #{params.inspect} cookie: #{cookies[:journal_entry]} session: #{session[:journal_entry]}"
    redirect_to login_path if !current_user
  end

  private

  def journal_entry_params
    params.permit(:survey, :state, :journal, :follow_up, :group_id)
  end
end