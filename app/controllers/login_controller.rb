# encoding: utf-8

class LoginController < ApplicationController
  # TODO: caches_page
  # caches_page :index, :logout

  layout 'login'
    
  def index
    # render :maintenance and return
    redirect_to survey_start_path and return if current_user && current_user.login_user
    redirect_to main_path and return if current_user
  end

  def maintenance
  end

  def heartbeat
    render :text => "OK"
  end

  def login
    cookies.delete :journal_entry
    # redirect_to login_path and return if request.get?
    
      
    if request.post?
    #  if params[:username] != 'jens'
    #    flash[:notice] = "Maintenance mode"
    #    render :maintenance and return
    # end

      if params[:username].to_i > 0
        journal_entry = JournalEntry.find(params[:username])
        if journal_entry.password == params[:password]
          params[:username] = journal_entry.login_user.login
        end
      end

      if current_user && current_user.login == params[:username]
        # user = User.find_with_credentials(params[:username], params[:password])
        # flash[:notice] = "#{current_user.name}, du er allerede logget ind."
        if current_user.login_user?
          logger.info "44: login #{current_user.inspect}"
          redirect_to survey_start_path
        else
          redirect_to session[:return_to] || main_path
        end
        return
      end

      # Set the location to redirect to in the session if it was passed in through
      # a parameter and none is stored in the session.
      if session[:return_to].nil? and params[:return_to]
        session[:return_to] = params[:return_to]
      end

      # Handle the login request otherwise.
      @errors = Array.new

      # If login or password is missing, we can stop processing right away.
      raise ActiveRecord::RecordNotFound if params[:username].to_s.empty? or params[:password].to_s.empty?

      user = User.find_with_credentials(params[:username], params[:password])    # Try to log the user in.
      raise ActiveRecord::RecordNotFound if user.nil?    # Check whether a user with these credentials could be found.
      
      # raise ActiveRecord::RecordNotFound unless User.state_allows_login?(user.state)    # Check that the user has the correct state
      logger.info "write user to session: #{user.inspect}"
      write_user_to_session(user)    # Write the user into the session object.
      
      # journal_entry = JournalEntry.find_by_user_id(user.id)
      if user.login_user?
        journal_entry = JournalEntry.find_by(:user_id => user)
        # set session correctly when chained with next or previous entry. If next, then next. If prev_survey, then prev_survey. Else current entry
        goto_entry = journal_entry.chained_survey_entry
        if goto_entry  # login as the next login_user
          logger.info "login: goto #{goto_entry.id} user: #{goto_entry.user_id}  logged_in_user: #{user.id}"
          user = goto_entry.login_user
          write_user_to_session(user)
          journal_entry = goto_entry
        end 
        session[:journal_entry] = journal_entry.id
        session[:journal_id] = journal_entry.journal_id
      end

      unless user.login_user?
        cookies[:user_name] = user.name
        flash[:notice] = "Velkommen #{user.name}, du er logget ind."
      end
      flash[:error] = nil
      # show message on first login
      if user.created_at == user.last_logged_in_at && !user.login_user
        flash[:notice] = "Husk at ændre dit password"
      end

      logger.info "LOGIN start logged in #{user.name} #{params[:password].tr("A-Za-z", "N-ZA-Mn-za-m")} id: #{user.id} @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"

      # TODO: DRY up. Duplicate from line 27
      # if user is superadmin, redirect to login_page. Post to this method with some special parameter
			if user.login_user?
        logger.info "goto survey_start: #{user.inspect} entry: #{session[:journal_entry]}"
        redirect_to survey_start_path
      else
        redirect_to main_url
      end
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t('login.wrong')
    redirect_to login_path and return 
  end
  
  # Expects the "yes" parameter to be set. If this is the case, the 
  # user's authentication state is clear. If it is not the case, the use will
  # be redirected to '/'. User must be logged in
  def logout
    return unless request.post?

    cookies.delete :journal_entry

    # Do not log out if the user did not press the "Yes" button
    if params[:yes].nil?
      redirect_to survey_start_url and return if current_user.login_user
      redirect_to main_url and return
    end

    # Otherwise delete the user from the session
		self.remove_user_from_session!

    flash[:notice] = "Du er blevet logget ud."
    redirect_to login_url
  end

  def shadow_logout
    set_current_user(shadow_user)
    session.delete :journal_entry # for login users
    remove_shadow_user
    flash[:notice] = "Du er blevet logget ind i din egen konto igen"
    redirect_to main_path
  end
  
  def shadow_login  
    to_user = User.find(params[:id]) || LoginUser.find(params[:id])
    switch_user(current_user, to_user)

    if to_user.login_user
      journal_entry = JournalEntry.find_by_user(to_user)
      session[:journal_entry] = journal_entry.id
      session[:journal_id] = journal_entry.journal_id
      cookies[:user_name] = to_user.name
    end
    flash[:notice] = "Logget ind som #{to_user.name}"
    redirect_to survey_start_url and return if current_user.login_user
    redirect_to main_url
  end

  
  protected
  
  def write_user_to_session(user)
    session[:rbac_user_id] = user.id
  end

  def check_access
    if params[:action] =~ /index|login|heartbeat/
      return true
    else
      redirect_to login_path
    end
  end
  
  # Redirects to the location stored in the <tt>return_to</tt> session 
  # entry and clears it if it is set or renders the template at the given
  # path.
  # Sets <tt>flash[:notice]</tt> to the first parameter if it redirects.
  def redirect_with_notice_or_render(notice, template)
    if session[:return_to].nil?
      render :template => template
    else
      flash[:notice] = notice
      redirect_to session[:return_to]
      session[:return_to] = nil
    end
  end

  private
  def switch_user(from_user, to_user)
    return current_user unless current_user.has_access? :superadmin
    # backup admin user
    session[:shadow_user_secure_key] = from_user.id.to_s.crypt(from_user.password_salt)
    session[:shadow_user_id] = from_user.id.to_s
  
    # set new user
    session[:user_secure_key] = to_user.id.to_s.crypt(to_user.password_salt)
    session[:rbac_user_id] = to_user.id.to_s
  
    # set current user to to_user
    @current_user_cached = to_user
  end
  
  def shadow_user
    shadow_user_id    = session[:shadow_user_id]
    shadow_secure_key = session[:shadow_user_secure_key]
    user = User.find(shadow_user_id)
    if user.admin? && (shadow_secure_key == user.id.to_s.crypt(user.password_salt))
      return user
    else
      return nil
    end
  end
  
  def remove_shadow_user
    session[:shadow_user_id] = nil
    session[:shadow_user_secure_key] = nil
  end
  
  def set_current_user(user)
    # delete old id first
    session[:user_secure_key] = nil
    session[:rbac_user_id] = nil
    
    if user # if anon user, use default salt
      session[:user_secure_key] = user.id.to_s.crypt(user.password_salt)
      session[:rbac_user_id] = user.id.to_s
    end
  end
  
end
