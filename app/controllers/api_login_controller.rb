require 'json'

class ApiLoginController < ApiController

	# protect_from_forgery
 	before_filter :cors_preflight_check
 	after_filter :cors_set_access_control_headers


	def start
		logger.info "api_login/start check_access: #{params.inspect}"
	    token = params[:token]

		puts "current_user: #{current_user.inspect}"
		login_user = LoginUser.find(current_user.id)
	    @journal_entry = login_user.journal_entry
	    puts "entry: #{@journal_entry.inspect}"
	    session[:journal_entry] = @journal_entry.id
	    session[:journal_id] = @journal_entry.journal_id
	    session[:api_key] = params[:api_key]
	    session[:token] = token
	    @center = login_user.center
	    redirect_to login_path and return if @journal_entry.nil?
	    redirect_to api_survey_start_path(params[:api_key], token)
  	end

  	def logout
  		logger.info "find api_key: #{params[:api_key] || session[:api_key]}"
  		api_key = ApiKey.find_by_api_key (params[:api_key] || session[:api_key])
  		logger.info "Return to: #{api_key.return_to}"
		goto = "#{api_key.return_to}?#{params[:token]}" 
		logger.info "goto: #{goto}"
 		redirect_to goto
		
		ensure
		session[:rbac_user_id] = nil
    	# session.delete :journal_entry
		cookies.delete :journal_entry
  		cookies.delete :journal_id
    	cookies.delete :user_name
		session.clear
 		reset_session
		logger.info "Ensure we're logged out"
	end

# http://0.0.0.0:3000/api_login/create application/json
# {"api_key":"13ccb7d0d0347440e7d62aa5a148f583","journal":{"name":"Test Testesen","gender":"f","birthdate":"2015-10-15"},"surveys":["CBCL_6-16", "TRF_6-16"]}
	def create
		param = ActiveSupport::JSON.decode(request.raw_post)
		puts "param: #{param.class} #{param.inspect}"
		key = param["api_key"]

		puts "key: #{key}"
		# check api_key
		api_key = ApiKey.find_by_api_key(key)
		if api_key.nil?
			render :text => "Not found" and return
		end

		puts "current_user: #{current_user.inspect}"

		journal_params = param["journal"]

		center = Center.find(api_key.center_id || 1) # TODO: fix

		# journal = Journal.where(center_id: center.id, title: journal_params["name"], cpr: get_cpr(journal_params["birthdate"])).first
		survey_params = param["surveys"].map {|s| s.split("_")}.map {|e| {category: e.first, age: e.last} }
		surveys = survey_params.map {|s| Survey.where(s).first}
		service = JournalService.new
		follow_up = 0
		journal, tokens = create_journal(center, journal_params, surveys, follow_up, true)
		puts "new journal: #{journal.inspect} tokens: #{tokens.inspect}"
		tokens

		if !tokens.any?
			puts "existing journal: #{journal.inspect}"
			tokens = to_token(journal)
		end

		puts "tokens: #{tokens.inspect}"
		encrypted_tokens = encrypt_tokens(api_key, tokens)

		# TODO: Kristian vil gerne have et ID på journalen. Check hvad han mente (se papir)
		puts "Tokens: #{tokens.inspect}  Encrypted tokens: #{encrypted_tokens.inspect}"
		render :text => encrypted_tokens # "#{journal.title}: #{journal.birthdate}   #{encrypted_tokens.inspect}"
	end

	def open # login og åbne skema
		render :text => "INVALID REQUEST: OPEN" and return
		# param = ActiveSupport::JSON.decode(request.raw_post)
		# puts "param: #{param.class} #{param.inspect}"

		# key = param["api_key"]

		# puts "key: #{key}"
		# api_key = ApiKey.find_by_api_key(key)
		# if api_key.nil?
		# 	render :text => "Not found" and return
		# end

		# token = params["token"]
		# login = eval(api_key.unlock token)
		# puts "token: #{token}  login: #{login.inspect}  #{login['login']}"

		# login_user = LoginUser.where(center_id: api_key.center_id, login: login["login"]).first
		# user = User.find_with_credentials(login["login"], login["password"])
		
		# if login_user.nil?
		# 	render :text => "User not found" and return
		# end
		# puts "login_user: #{login_user.inspect}  user: #{user.inspect} #{user.nil?}"
		# write_user_to_session(user)

		# entry = login_user.journal_entry

		# session[:journal_entry] = entry.id
  #   session[:journal_id] = entry.journal_id

  #   login_user = current_user
  #   logger.info "open, current_user: #{login_user.inspect}"
  #   render :text => ( "/api_login" + survey_start_path + "/" + key + "/" + token)
		# render :text => "#{entry.journal.name} #{entry.survey.short_name}"		
	end


	def index
		key = if request.post?
			param = ActiveSupport::JSON.decode(request.raw_post)
			puts "param: #{param.class} #{param.inspect}"
			key = param["api_key"]
		elsif request.get?
			key = params[:api_key]
		end
		puts "key: #{key}"
		# check api_key
		api_key = ApiKey.find_by_api_key(key)
		if api_key.nil?
			render :text => "Not found" and return
		end

		center = api_key.center
		response = center.journals.map {|j| {j.title => encrypt_tokens(api_key, to_token(j))}}.join("<br/>")
		render :text => response
	end

	def check_access
		return true
	end


	def cors_set_access_control_headers
	  headers['Access-Control-Allow-Origin'] = '*'
	  headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
	  headers['Access-Control-Allow-Headers'] = '*'
	  headers['Access-Control-Max-Age'] = "1728000"
	end
	
	# If this is a preflight OPTIONS request, then short-circuit the
	# request, return only the necessary headers and return an empty
	# text/plain.
	
	def cors_preflight_check
		if request.method == :options
			headers['Access-Control-Allow-Origin'] = '*'
			headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
			headers['Access-Control-Request-Method'] = '*'
			headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'	    
			render :text => '', :content_type => 'text/plain'
		end
	end

	private 

	def to_token(journal)
		journal.not_answered_entries.inject({}) do |h, e| 
			h[e.survey.short_name] = {"login" => e.login_user.login, "password" => e.password}
			h
		end
	end

	def encrypt_tokens(api_key, tokens)
		encrypted_tokens = tokens.inject({}) {|h,login| h[login.first] = api_key.lock(login.last.to_s); h }
	end

	def get_cpr(date_str)
    	dato = date_str.split("-")
    	dato[0] = dato[0][2..3]
    	dato.reverse.join
	end

  protected
  
  def write_user_to_session(user)
    session[:rbac_user_id] = user.id
  end


  private

  	def create_journal(center, journal_params, surveys, follow_up = 0, save = true)
		journal = Journal.where(center_id: center.id, title: journal_params["name"], cpr: get_cpr(journal_params["birthdate"])).first

		if !journal
			puts "create_journal #{journal_params.inspect}"
			date = DateTime.parse(journal_params["birthdate"])
			puts "birthdate: #{date.inspect}"
			name = journal_params["name"]
			gender = journal_params["gender"]

			journal = Journal.new(title: name, sex: Journal.sexes[gender], birthdate: date, 
				nationality: "Dansk")
			journal.code = center.next_journal_code
			journal.set_cpr_nr
			puts "create_journal: #{journal.inspect}"
			journal.center = center
			journal.group_id = center.id

			if !journal.valid?
				puts "ERRORS: #{journal.errors.inspect}"
				return [journal, {}]
			end

		else # create surveys if not exist
			logger.info "existing create_journal #{journal_params.inspect}"
			surveys = surveys.select do |survey|
				# !journal.not_answered_entries.any? {|e| e.survey_id == survey.id }
				!journal.journal_entries.any? {|e| e.survey_id == survey.id && e.follow_up == follow_up }
			end
		end

		entries = journal.create_journal_entries(surveys, follow_up = 0, save)
		logger.info("created entries: #{entries.inspect}")
		logins = entries.inject({}) do |col,e|
	    	    col[e.survey.short_name] = {"login" => e.login_user.login, "password" => e.password}
		    col
		end
		if !logins.any?
			return [journal, {:result => 0, :message => 'No surveys created and logins created, already exists and answered'}]
		end
		logger.info("logins: #{logins.inspect}")
	    
	    return [journal, logins]
	end

	def get_cpr(date_str)
    	dato = date_str.split("-")
    	
    	# puts "dato: #{dato.inspect}  [2].length #{dato[2].length}"
    	if dato[2].length == 4
    		year, month, day = *(dato.reverse)
    	elsif dato.first.length == 4
    		year, month, day = *dato
    	else
    		raise "Invalid date: #{date_str}"
    	end

    	# puts "day: #{day}, month: #{month}, year: #{year}"
    	return "#{day}#{month}#{year.slice(2, 2)}"
	end

end