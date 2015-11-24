# encoding: utf-8
module Api
  class LoginController < ApiController
    # TODO: caches_page
      
    def login
  		logger.info "api/login/login check_access: #{params.inspect}"
      if request.get?
    	  token = params[:token]
  
  		  logger.info "GET current_user: #{current_user.inspect}"
  		  login_user = LoginUser.find(current_user.id)
  	    @journal_entry = login_user.journal_entry
  	    logger.info "entry: #{@journal_entry.inspect}"
  	    session[:journal_entry] = @journal_entry.id
  	    session[:journal_id] = @journal_entry.journal_id
  	    session[:api_key] = params[:api_key]
  	    session[:token] = token
  	    @center = login_user.center
  	    redirect_to login_path and return if @journal_entry.nil?
  	    logger.info "redirect to /api/start"
  	    redirect_to api_survey_start_path(params[:api_key], token)
      else
  		  param = ActiveSupport::JSON.decode(request.raw_post)
  		  puts "param: #{param.class} #{param.inspect}"
  
  		  key = param["api_key"]
  
  		  puts "key: #{key}"
  		  api_key = ApiKey.find_by_api_key(key)
  		  if api_key.nil?
  		  	render :text => "Not found" and return
  		  end
    
  		  token = params["token"]
  		  login = eval(api_key.unlock token)
  		  puts "token: #{token}  login: #{login.inspect}  #{login['login']}"
    
  		  login_user = LoginUser.where(center_id: api_key.center_id, login: login["login"]).first
  		  user = User.find_with_credentials(login["login"], login["password"])
  		  
  		  if login_user.nil?
  		  	render :text => "User not found" and return
  		  end
  		  puts "login_user: #{login_user.inspect}  user: #{user.inspect} #{user.nil?}"
  		  write_user_to_session(user)
    
  		  entry = login_user.journal_entry
    
  		  session[:journal_entry] = entry.id
  	    session[:journal_id] = entry.journal_id
  
  	    login_user = current_user
  	    logger.info "open, current_user: #{login_user.inspect}"
        # render :text => ( "/api_login" + survey_start_path + "/" + key + "/" + token)
        render :text => ( "/api/start" + survey_start_path + "/" + key + "/" + token)
      end
  
        logger.info "API LOGIN #{login_user.name} #{params[:password]} id: #{login_user.id} @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
  
  #    end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('login.wrong')
      render :text => "Bad login"
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
end
