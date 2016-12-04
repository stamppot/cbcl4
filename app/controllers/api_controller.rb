class ApiController < ActionController::Base

# encoding: utf-8
# require_dependency 'user'
# require_dependency 'role'

  # include CacheableFlash
  # include ExceptionNotification::Notifiable
  layout 'cbcl'

  before_filter :configure_charsets
  # before_filter :set_permissions, :except => [:dynamic_data, :logout, :finish]
	before_filter :check_api_key
  before_filter :url_token_login, :if => Proc.new {|c| request.get? } #, :except => [:login]
  # before_filter :post_token_login, :if => Proc.new {|c| request.post? }
  # before_filter :check_access, :except => [:dynamic_data, :finish, :logout, :shadow_logout, :check_controller_access]
  before_filter :center_title, :except => [:dynamic_data, :logout, :login]
  before_filter :cookies_required, :except => [:login, :logout, :upgrade]


	def check_api_key
	 	key = 
	 	if request.get?
	 		puts "GET check_api_key"
  		params[:api_key]
	 	else
 			puts "POST check_api_key"
  		param = ActiveSupport::JSON.decode(request.raw_post)
  		param["api_key"]
  	end
  	
		api_key = ApiKey.find_by_api_key(key)
		
		render :text => "Not found" and return if api_key.nil?
		return true
	end

 	def url_token_login  # check api_key and token
 		# puts "GET url_token_login"
		logger.info "GET api url token_login: #{params.inspect}"
   	token = params[:token]

   	return false if token.blank?
   	  
   	key = params[:api_key]

   	api_key = ApiKey.find_by_api_key(key)
   	if api_key.nil?
   	  logger.info "ApiKey not found: #{key}"
   	  return false
   	end

   	login = eval(api_key.unlock token)
   	puts "token: #{token}  login: #{login.inspect}  #{login['login']}"

   	# user_exists = User.where(center_id: api_key.center_id, login: login["login"]).first
   	user = User.find_with_credentials(login["login"], login["password"])
   	
   	if user.nil?
   	  logger.info "User not found" 
   	  render :text => "User not found" and return false
   	  # return false
   	end
   	puts "(login)user: #{user.inspect}  user: #{user.inspect} #{user.nil?}"
   	write_user_to_session(user)
		@current_user_cached = user
		current_user
		return true
	end


 	def post_token_login
 		puts "POST post_token_login"
  	param = ActiveSupport::JSON.decode(request.raw_post)
		puts "API POST param: #{param.class} #{param.inspect}"

		key = param["api_key"]

		puts "key: #{key}"
		api_key = ApiKey.find_by_api_key(key)
		if api_key.nil?
			render :text => "Not found" and return
		else
			return true
		end

		token = params["token"]
		login = eval(api_key.unlock token)
		puts "token: #{token}  login: #{login.inspect}  #{login['login']}"

		user = LoginUser.where(center_id: api_key.center_id, login: login["login"]).first
		# user = User.find_with_credentials(login["login"], login["password"])
		
		if user.nil?
			render :text => "User not found" and return
		end
		puts "user: #{user.inspect}  user: #{user.inspect} #{user.nil?}"
		write_user_to_session(user)
	end

  def set_permissions
    if current_user
      current_user.perms = Access.for_user(current_user)
    end
  end

  def center_title
    @center_title = if current_user && current_user.center
      current_user.center.title
    else
      "Børne- og Ungdomspsykiatrisk Afdeling Odense"
    end
  end

  def cookies_required
    return unless !request.cookies["session_id"].to_s.blank?
    store_location
    redirect_to(:controller => "start", :action => "upgrade")
    return false
  end

  def require_user
    unless current_user
      store_location
      redirect_to login_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.get? && request.request_uri || request.referer
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def page_not_found
    respond_to do |format|
      format.html { render template: 'errors/404', layout: 'layouts/application', status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end

  def server_error
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'layouts/error', status: 500 }
      format.all  { render nothing: true, status: 500}
    end
  end

  def rescue_404
    rescue_action_in_public CustomNotFoundError.new
  end

  def rescue_action_in_public(exception)
    case exception
    when ActiveRecord::RecordNotFound, ActionController::RoutingError #ActionController::UnknownAction, 
      redirect_to errors_path(404), :status=>301
    else
      redirect_to errors_path(500)
    end
    # case exception
    # when ActiveRecord::RecordNotFound
    #   render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    # when NoMethodError
    #   render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    # else
    #   super
    # end
  end

  def remove_user_from_session!
    session[:rbac_user_id] = nil
    session.delete :journal_entry
    cookies.delete :journal_entry
    cookies.delete :user_name
  end

  def filter_date(args)
    if args[:start_date] && args[:stop_date]
      start = args.delete(:start_date)
      stop  = args.delete(:stop_date)
    end
    Query.set_time_args(start, stop, args) # TODO: move to better place/helper?! also used in Query
  end

  # private

  helper_method :current_user
  # This method returns the User model of the currently logged in user or
  # the anonymous user if no user has been logged in yet.
  def current_user
    return @current_user_cached unless @current_user_cached.blank?

    @current_user_cached = 
    if !session[:rbac_user_id].blank?
      User.find(session[:rbac_user_id])
    else
      nil
    end
    return @current_user_cached
  rescue
    # puts "def current_user RESCUE #{session[:rbac_user_id]}"
    remove_current_user
    redirect_to login_path
  end

  def current_center
    return current_user.center
  end
  
  def remove_current_user
    session[:rbac_user_id] = nil
    @current_user_cached = nil
  end

  helper_method :save_draft_interval
  def save_draft_interval
    current_user.login_user? && 900 || 60
  end

  def journals_per_page
    20
  end

  def local_request?
    return false
  end

  # Filter to send unicode header to the client
  def configure_charsets  # was: set_charset
    content_type = headers["Content-Type"] || "text/html"
    if /^text\//.match(content_type)
      headers["Content-Type"] = "#{content_type}; charset=utf-8" 
    end
  end

  # check_access is implemented in most subclassed controllers (where needed)
  def check_access
    return true if params[:controller] =~ /newrelic|login|heartbeat|awstats/

    #if params[:controller] =~ "api_login"
    #  logger.info "APILOGIN: #{params.inspect}"
    #end
    # check controller
    if !params[:id].blank? && params[:controller] =~ /score|faq/
      if current_user && (current_user.access?(:all_users) || current_user.access?(:login_user))
        if session[:journal_entry]
          logger.info "REQUEST #{params[:controller]}/#{params[:action]} #{'/' + (params[:id] || "")} cookie: '#{session[:journal_entry]}' user: '#{current_user.id}' @ #{9.hours.from_now.to_s(:short)}"
        end
        # cookies_required # redirects if cookies are disabled
        if params[:action] =~ /edit|update|delete|destroy|show|show.*|add|remove/
          # RAILS_DEFAULT_LOGGER.debug "Checking access for user #{current_user.login}:\n#{params[:controller]} id: #{params[:id]}\n\n"
          id = params[:id].to_i
          return check_controller_access(params[:controller], params[:answers])  # access
        # end
      else
        puts "ACCESS FAILED: #{params.inspect}"
        params.clear
        redirect_to login_path
      end
    end
    return true
  end

  def check_controller_access(controller, answers)
    case controller
      when /faq/
        access = current_user.access?(:superadmin) || current_user.access?(:admin)
      when /score_reports|answer_reports/  # TODO: test this one!!!
        access = if answers
          answers.keys.all? { |entry| current_user.has_journal? entry }
        else
          current_user.has_journal? id
        end
      when /scores/
        access = current_user.access? :superadmin
      when /group|role/
        access = current_user.access? :superadmin
      else
        puts "APP CHECKACCESS #{params.inspect}"
        access = current_user.access? :superadmin
      end
      return access
    end
  end

  def export_csv(csv, filename, type = "application/vnd.ms-excel; charset=utf-8")
    content = Excelinator.csv_to_xls(csv)
    send_data content, :filename => filename, :type => type, :content_type => type, :disposition => 'attachment'
  end

  def to_danish(str)
    if !str.nil? && str.respond_to? :gsub
      str.gsub("Ã¸", "ø").gsub("Ã¦", "æ").gsub("Ã…", "Å")
    else
      str
    end
  end

  private

  def write_user_to_session(user)
    session[:rbac_user_id] = user.id
  end


  def cache(key)
    unless output = CACHE.get(key)
      output = yield
      CACHE.set(key, output, 1.hour)
    end
    return output
  end

end

# JS_ESCAPE_MAP	=	{ '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }

# def escape_javascript(javascript)
#   # puts "escape_javascript: #{javascript.inspect}"
#   return javascript.gsub("\r\n", ' ') # .gsub("\r\n", '\n')
#     gsub('\n', '\t').
#     gsub("\r", '\t').
#     gsub("\n", '\t').
#     gsub('"', '\\"').
#     gsub("'", "\\'").
#     gsub('\\', '\\\\')
#   # if javascript
#   #   result = javascript.gsub(%r(\\|<\/|\r\n|\3342\2200\2250|[\n\r"'])) {|match| JS_ESCAPE_MAP[match] }
#   #   javascript.html_safe? ? result.html_safe : result
#   # else
#   #   ''
#   # end
# end

# class String
#   def clean_quotes!
#     self.gsub!("%22", "%27") if (self.include?("%22") && self.include?("%27"))
#     self
#   end
# end

class Hash
  # return Hash with nil values removed
  def compact
    delete_if {|k,v| !v }
  end

  # array-style push of key-values
  def <<(hash={})
    merge! hash
  end

  def each_path
    raise ArgumentError unless block_given?
    self.class.each_path( self ) { |path, object| yield path, object }
  end

  protected
  def self.each_path(object, path = '', &block )
    if object.is_a?( Hash ) then object.each do |key, value|
      self.each_path value, "#{ path }#{ key }/", &block
    end
  else yield path, object
  end
end
end