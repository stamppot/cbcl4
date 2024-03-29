# encoding: utf-8

class SurveysController < ApplicationController
  ActionController::Base.perform_caching = false
  helper SurveyHelper
  layout 'cbcl', :except => [ :show, :show_fast, :show_answer, :show_answer2 ]
  layout "jsurvey", :only  => [ :show, :show_fast, :show_answer, :edit, :show_answer2, :change_answer ]

 # caches_page :show, :if => Proc.new { |c| entry = c.request.env['HTTP_COOKIE'].split(";").last; entry =~ /journal_entry=(\d+)/ }
  
  # 19-2-8 TODO: replace in_place_edit with some other edit function
  # in_place_edit_for :question, :number

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => "post", :only => [ :destroy, :create, :update, :answer ],
  # :redirect_to => { :action => :list }

  def index
    @page_title = "CBCL Spørgeskemaer"
    @surveys = []
    if current_user.nil?
      flash[:error] = "Du er ikke logget ind"
      redirect_to login_path
    else
      @surveys = User.find(session[:rbac_user_id]).subscribed_surveys || [] #current_user.subscribed_surveys || []
      render(:layout => "layouts/cbcl")
    end
  end

  # for showing surveys without being able to answer them (sort demo-mode)
  def show_only
    @options = {:show_all => true, :show_only => true, :action => 'show_answer', :validation => true}
    survey_id = params[:id].to_i
    @survey = Survey.and_questions.find(params[:id])
    @color = @survey.color
    @page_title = @survey.get_title
    # flash[:notice] = "Denne side viser ikke et brugbart spørgeskema. Du har tilgang til besvarelser gennem journaler."
    render :template => 'surveys/show', :layout => "layouts/jsurvey"
  end
  
  def show_only_fast
    @options = {:show_all => true, :show_only => true, :action => 'show_answer'}
    @survey = Survey.and_questions.find(params[:id])
    @page_title = @survey.get_title
    render :template => 'surveys/show_fast', :layout => "layouts/survey_fast"
  end

  def show
    @options = {:show_all => true, :action => "create", :validation => false}

    journal_entry = JournalEntry.find(session[:journal_entry])
    logger.info("SURVEY get entry from session: #{journal_entry.id}... current_user: #{current_user.inspect}")
    cookies[:journal_entry] = journal_entry.id
    #journal_entry = JournalEntry.find(cookies[:journal_entry]) if session[:journal_entry].blank?
    
    @journal = journal_entry.journal
    @is_login_user = current_user.login_user?
     
    @survey = Survey.and_questions.find(params[:id])

    @color = @survey.color
    @page_title = @survey.get_title

    cookies[:show_only_question] = { :value => @survey.question_with_problem_items.id, :expires => 2.hour.from_now } if session[:token]

    # render :text => "Survey: #{@survey.inspect}" and return
    # raise ActiveRecord::RecordNotFound "SURVEY: #{@survey.inspect}: answer_by: #{@answer_by.inspect}"
      rescue ActiveRecord::RecordNotFound
   end

  # non-caching method
  def show_fast                             # 11-2 it's fastest to preload all needed objects
    # redirect_to maintenance_path and return
    @options = {:action => "create", :hidden => true, :fast => true}
    logger.info "show_fast session: #{session[:journal_entry]}"
    @journal_entry = JournalEntry.find(session[:journal_entry])
    cookies[:journal_entry] = @journal_entry.id
    logger.info "SHOWFAST JOURNAL_ENTRY: #{@journal_entry.inspect}"
    @journal = @journal_entry.journal
    survey_id = @journal_entry.survey_id
    # puts "show_fast survey: #{survey_id}"
    @survey = Survey.and_questions.find(survey_id)

    @page_title = @survey.get_title
  
    @survey_fast_answer = nil
    if @journal_entry.survey_answer.nil?  # survey_answer not created before
      @journal = @journal_entry.journal
      @survey_fast_answer = SurveyAnswer.create(:survey_id => @survey.id, :age => @journal.age, :sex => @journal.sex_text, 
        :journal => @journal, :surveytype => @survey.surveytype, :nationality => @journal.nationality, 
        :journal_entry => @journal_entry, :center_id => @journal.center_id)
      @survey_answer_json = @survey_fast_answer.answers.map {|a| a.answer_cells.map {|cell| CellJson.new(cell) } }.flatten.to_json
      # puts "#{@survey_answer_json.inspect}"
    else  # survey_answer was started/created, so a draft is saved
      survey_answer = SurveyAnswer.and_answer_cells.and_questions.includes(:survey => :questions).where(:id => @journal_entry.survey_answer_id).first # removed .and_answers
      @survey_answer_json = survey_answer.answers.map {|a| a.answer_cells.map {|cell| CellJson.new(cell) } }.flatten.to_json
      # puts "#{@survey_answer_json.inspect}"
    end
    unless @journal_entry.survey_answer
      @journal_entry.survey_answer = survey_answer
      @journal_entry.save
    end
    render :layout => "layouts/survey_fast"
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Kunne ikke finde skema for journal."
      redirect_to surveys_path
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      flash[:notice] = 'Spørgeskemaet er oprettet.'
      redirect_to surveys_path
    else
      render new_survey_path
    end
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  
  def update
    @survey = Survey.find(params[:id])
    expire_page :action => :show, :id => @survey

    if @survey.update_attributes(params[:survey])
      flash[:notice] = 'Spørgeskemaet er opdateret.'
      redirect_to surveys_path
    else
      render :edit
    end
  end

  def destroy
    Survey.destroy(params[:id])
    flash[:notice] = "Spørgeskema er slettet"
    redirect_to surveys_path
  end

  def print
    redirect_to print_survey_path(params[:id])
  end

  
  protected
  
  before_filter :superadmin_access, :only => [ :new, :edit, :update, :create, :delete, :destroy ]


  def superadmin_access
    unless current_user.access? :superadmin
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to main_path
    end
  end
  
  def check_access
    redirect_to login_path and return unless current_user
    id = params[:id].to_i

    access = false
    if current_user.access?(:all_users) || current_user.login_user?  
      access = if params[:action] =~ /show_only/
        current_user.surveys.map {|s| s.id }.include?(id)
      elsif current_user.access? :superadmin # don't do check for superadmin
        true
      end
    end

    if id < 12  # survey_id
      access = true
    end

    if current_user.login_user?
      journal_entry_id = id <= 210 && session[:journal_entry] || params[:id]  # if survey_id, use session_id 
      access = current_user.has_journal_entry?(journal_entry_id)
      if !access
        logger.info "check_access NO ACCESS survey: current_user: #{current_user.inspect} params: #{params.inspect} cookie: #{cookies[:journal_entry]} session: #{session[:journal_entry]}"
        redirect_to login_path
      end
    end
    return access
  end
end
