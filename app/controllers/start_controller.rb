class StartController < ApplicationController

  def start
    session.delete :journal_entry  # clean up from login with chained surveys

    token = params[:token]
    if token

    end
    user_name = cookies[:user_name]
    cookies.delete :user_name # if current_user.login_user?
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    @is_first_of_chained_survey = true if chained = @journal_entry.chained_survey_entry
    #   @journal_entry = chained unless chained.answered?
    # end
    # logger.info "Start: current_user: #{current_user.inspect} journal_entry: #{@journal_entry.inspect}"
    @name = @journal_entry.journal.title
    @center = @journal_entry.journal.center
    session[:journal_entry] ||= @journal_entry.id
    session[:journal_id] ||= @journal_entry.journal_id
    session[:api_key] = params[:api_key]
    session[:token] = params[:token]
    j = @journal_entry.journal
    je = @journal_entry
    time = 9.hours.from_now.to_s(:short)
    if session[:journal_entry].to_i != je.id  # MUST be the same entry, or a wrong survey will be opened
      logger.info "WRONG entry: in session[:journal_entry] #{session[:journal_entry]}, loaded: #{je.id}"
      raise RunTimeError "Bad entry in session: WRONG entry: in session[:journal_entry] #{session[:journal_entry]}, loaded: #{je.id}"
    end
    logger.info "LOGIN_USER start #{user_name} journal: #{j.id} #{j.title} kode: #{j.code} journal session: #{session[:journal_id]} entry session: '#{session[:journal_entry]}' entry: '#{je.id}' survey: #{je.survey_id} luser: '#{je.user_id}' @ #{time}: #{request.env['HTTP_USER_AGENT']}"
    @token = session[:token] || params[:token]
    @api_key = session[:api_key] || params[:api_key]
    cookies[:journal_entry] = { :value => session[:journal_entry], :expires => 5.hour.from_now }
    cookies[:journal_id] = { :value => session[:journal_id], :expires => 5.hour.from_now }

    redirect_to survey_continue_path(@api_key, @token) if @journal_entry.draft?

    if @journal_entry.answered?
      # if chained, 
      redirect_to survey_finish_path(@journal_entry, @api_key, @token) and return if @journal_entry.answered?
    end

    @survey = @journal_entry.survey
    cookies[:show_only_question] = { :value => @survey.question_with_problem_items.id, :expires => 2.hour.from_now } if session[:token]
  end

  def continue
    # if !current_user.name.include? 'Jens'
    #   flash[:notice] = "System er under vedligeholdelse. Kom tilbage senere."
    #   redirect_to maintenance_path and return
    # end
    # @token = session[:token]
    # @api_key = session[:api]
    @token = params[:token]
    @api_key = params[:api_key]
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    je = @journal_entry
    @journal = je.journal
    @center = @journal.center
    cookies[:journal_entry] = @journal_entry.id # session[:journal_entry]
    cookies[:journal_id] = @journal_entry.journal_id
    user_name = je.login_user.name
    logger.info "LOGIN_USER conti #{user_name} journal: #{@journal.title} entry session: '#{session[:journal_entry]}' entry: '#{je.id}' luser: '#{je.user_id}' @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    @survey = @journal_entry.survey
    cookies[:show_only_question] = { :value => @survey.question_with_problem_items.id, :expires => 2.hour.from_now } if session[:token]
  end

  def next
    logger.info "Next 0: params: #{params.inspect}"
    @journal_entry = JournalEntry.find(params[:id])
    if @journal_entry.next    # has next, but should be this one
	logger.info "Next problem: entry has next, should be this one?  params: #{params.inspect}  entry: #{@journal_entry.inspect}"
	jenext = JournalEntry.find @journal_entry.next
	jenextpw = jenext.password
    end
    login_user = @journal_entry.login_user
	  
    pw_hash = session[:pw_hash]
    if pw_hash
        if login_user.hash_string(@journal_entry.password) == pw_hash
		logger.info "Next: pw_hash matches!"
	end
    else
        logger.info "Next: No pw_hash, params: #{params.inspect}"
    end
	  
    if @journal_entry.next    # has next, but should be this one
        logger.info "Next problem: entry has next, should be this one?  params: #{params.inspect}  entry: #{@journal_entry.inspect}. Changing login_user to the one in next"
	@journal_entry = JournalEntry.find @journal_entry.next
	login_user = @journal_entry.login_user
    end
    user = User.find_with_credentials(login_user.login, @journal_entry.password)    # Try to log the user in.
    raise ActiveRecord::RecordNotFound if user.nil?    # Check whether a user with these credentials could be found.
    write_user_to_session(user) 

    logger.info "Next: journal_entry: #{@journal_entry.inspect} params: #{params.inspect}"
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
    logger.info "LOGIN_USER next #{user_name} journal: #{j.id} #{j.title} kode: #{j.code} entry session: '#{session[:journal_entry]}' entry: '#{je.id}' survey: #{je.survey_id} luser: '#{je.user_id}' @ #{time}: #{request.env['HTTP_USER_AGENT']}"
    if session[:journal_entry].to_i != je.id  # MUST be the same entry, or a wrong survey will be opened
      logger.info "WRONG next entry: in session[:journal_entry] #{session[:journal_entry]}, loaded: #{je.id}"
      raise RunTimeError "Bad next entry in session: WRONG entry: in session[:journal_entry] #{session[:journal_entry]}, loaded: #{je.id}"
    end
    # @token = session[:token]
    @continue_from_infosurvey = je.chained_survey_entry && je.is_infosurvey?
    @api_key = session[:api_key]
    cookies[:journal_entry] = { :value => session[:journal_entry], :expires => 5.hour.from_now }
    cookies[:journal_id] = { :value => session[:journal_id], :expires => 5.hour.from_now }
    # session.delete "token"

    @survey = @journal_entry.survey
    cookies[:show_only_question] = { :value => @survey.question_with_problem_items.id, :expires => 2.hour.from_now } if session[:token]

    redirect_to survey_continue_path(@token, @api_key) if @journal_entry.draft?
    redirect_to survey_finish_path(@journal_entry, @api_key, @token) and return if @journal_entry.answered?
  end

  def finish
    @journal_entry = JournalEntry.find_by_id_and_user_id(params[:id], current_user.id)
    if @journal_entry.answered? && (chained = @journal_entry.chained_survey_entry)
      if chained && !chained.answered?
        session[:journal_entry] = chained.id
        redirect_to survey_next_path(chained) and return
      end
    end
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
    session.delete :journal_entry
    puts "token: #{@token}"
    survey_answer = @journal_entry.survey_answer
    weeks_to_answer = CenterSetting.get(@center, "edit_answer_in_weeks", 2)
    @update_date = survey_answer && (survey_answer.created_at.end_of_day + weeks_to_answer.weeks) || Date.today
    @can_update_answer = @update_date >= Date.today

    @edit_chained = @journal_entry.chained_survey_entry
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

    if !current_user
	logger.info "Startcontroller: User not logged in. Params #{params.inspect}"
	return false
    end
	    
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil? 
  end

  def write_user_to_session(user)
    session[:rbac_user_id] = user.id
  end

end
