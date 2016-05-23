class StartController < ApplicationController

  def start
    token = params[:token]
    if token

    end
    user_name = cookies[:user_name]
    cookies.delete :user_name # if current_user.login_user?
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    # logger.info "Start: current_user: #{current_user.inspect} journal_entry: #{@journal_entry.inspect}"
    @name = @journal_entry.journal.title
    @center = @journal_entry.journal.center
    session[:journal_entry] ||= @journal_entry.id
    session[:journal_id] ||= @journal_entry.journal_id
    j = @journal_entry.journal
    je = @journal_entry
    time = 9.hours.from_now.to_s(:short)
    logger.info "LOGIN_USER start #{user_name} journal: #{j.id} #{j.title} kode: #{j.code} journal session: #{session[:journal_id]} entry session: '#{session[:journal_entry]}' entry: '#{je.id}' survey: je.survey_id luser: '#{je.user_id}' @ #{time}: #{request.env['HTTP_USER_AGENT']}"
    @token = session[:token]
    @api_key = session[:api_key]
    cookies[:journal_entry] = { :value => session[:journal_entry], :expires => 5.hour.from_now }
    cookies[:journal_id] = { :value => session[:journal_id], :expires => 5.hour.from_now }
    # session.delete "token"

    if @journal_entry.draft? && @token && @api_key
      logger.info "300 api_survey_continue_path"
      redirect_to api_survey_continue_path(@token, @api_key) and return
    end

    if @journal_entry.answered? && @token && @api_key
      logger.info "300 api_survey_finish_path"
      redirect_to api_survey_finish_path(@token, @api_key) and return
    end

    redirect_to survey_continue_path(@token, @api_key) if @journal_entry.draft?
    redirect_to survey_finish_path(@journal_entry, @api_key, @token) and return if @journal_entry.answered?
    @survey = @journal_entry.survey
  end

  def continue
    # if !current_user.name.include? 'Jens'
    #   flash[:notice] = "System er under vedligeholdelse. Kom tilbage senere."
    #   redirect_to maintenance_path and return
    # end
    # @token = session[:token]
    # @api_key = session[:api]
    @token = params[:token]
    @api_key = params[:api]
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    je = @journal_entry
    @journal = je.journal
    @center = @journal.center
    cookies[:journal_entry] = @journal_entry.id # session[:journal_entry]
    cookies[:journal_id] = @journal_entry.journal_id
    user_name = je.login_user.name
    logger.info "LOGIN_USER conti #{user_name} journal: #{@journal.title} entry session: '#{session[:journal_entry]}' entry: '#{je.id}' luser: '#{je.user_id}' @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    @survey = @journal_entry.survey
  end

  def next
    @journal_entry = JournalEntry.find(params[:id])
    login_user = @journal_entry.login_user
    user = User.find_with_credentials(login_user.login, @journal_entry.password)    # Try to log the user in.
    raise ActiveRecord::RecordNotFound if user.nil?    # Check whether a user with these credentials could be found.
    write_user_to_session(user) 

    logger.info "Next: current_user: #{current_user.inspect} journal_entry: #{@journal_entry.inspect}"
    @name = @journal_entry.journal.title
    @center = @journal_entry.journal.center
    session[:journal_entry] = @journal_entry.id
    session[:journal_id] = @journal_entry.journal_id
    @token = session[:token]
    @api_key = session[:api_key]
    user_name = cookies[:user_name]
    cookies.delete :user_name # if current_user.login_user?
    j = @journal_entry.journal
    je = @journal_entry
    time = 9.hours.from_now.to_s(:short)
    logger.info "LOGIN_USER next #{user_name} journal: #{j.id} #{j.title} kode: #{j.code} journal session: #{session[:journal_id]} entry session: '#{session[:journal_entry]}' entry: '#{je.id}' survey: je.survey_id luser: '#{je.user_id}' @ #{time}: #{request.env['HTTP_USER_AGENT']}"
    # @token = session[:token]
    @api_key = session[:api_key]
    cookies[:journal_entry] = { :value => session[:journal_entry], :expires => 5.hour.from_now }
    cookies[:journal_id] = { :value => session[:journal_id], :expires => 5.hour.from_now }
    # session.delete "token"

    @survey = @journal_entry.survey
    redirect_to survey_continue_path(@token, @api_key) if @journal_entry.draft?
    redirect_to survey_finish_path(@journal_entry, @api_key, @token) and return if @journal_entry.answered?
  end

  def finish
    @journal_entry = JournalEntry.find_by_id_and_user_id(params[:id], current_user.id)
    redirect_to survey_next_path(@journal_entry.next) and return if @journal_entry.next
    redirect_to survey_continue_path and return unless @journal_entry.answered?
    @survey = @journal_entry.survey
    @center = @journal_entry.journal.center
    # session.delete "journal_entry"
    # session.delete "journal_id"
    Rails.cache.delete("j_#{@journal_entry.id}")
    @token = session[:token]
    @api_key = session[:api_key]
    # session.delete "token"
    # session.clear
    cookies.delete :journal_entry
    cookies.delete :journal_id
    puts "token: #{@token}"
    survey_answer = @journal_entry.survey_answer
    @update_date = survey_answer && (survey_answer.created_at.end_of_day + 2.weeks) || Date.today
    @can_update_answer = @update_date >= Date.today
    logger.info "Editable until: #{@update_date.inspect}"
  end

  def upgrade
    render :layout => "layouts/cbcl"
  end
  
  def check_logged_in
    session["journal_entry"] != nil && current_user
  end

  def check_access
  	logger.info "start check_access: #{params.inspect}"
    token = params[:token]

    if token
      key = params[:api_key]

      api_key = ApiKey.find_by_api_key(key)
      if api_key.nil?
        logger.info "ApiKey not found: #{key}"
        return false
      end

      # puts "api_key: #{api_key.inspect}"
      login = eval(api_key.unlock token)
      puts "login: #{login.inspect}"
      puts "token: #{token}  login: #{login.inspect}  #{login['login']}"

      login_user = LoginUser.where(center_id: api_key.center_id, login: login["login"]).first
      user = User.find_with_credentials(login["login"], login["password"])
    
      if login_user.nil?
        logger.info "User not found" 
        return false
      end
      puts "login_user: #{login_user.inspect}  user: #{user.inspect} #{user.nil?}"
      write_user_to_session(user)
 	@current_user_cached = user
	current_user
      entry = login_user.journal_entry
      puts "entry: #{entry.inspect}"
      session[:journal_entry] = entry.id
      session[:journal_id] = entry.journal_id
    end

    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil? 
  end

  def write_user_to_session(user)
    session[:rbac_user_id] = user.id
  end

end