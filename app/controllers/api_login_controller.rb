require 'json'

class ApiLoginController < ApplicationController

	# protect_from_forgery
 	before_filter :cors_preflight_check
 	after_filter :cors_set_access_control_headers

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
		else
			# render :text => api_key.name and return
		end

		journal_params = param["journal"]

		center = Center.find(api_key.center_id || 1) # TODO: fix

		journal = Journal.where(center_id: center.id, title: journal_params["name"], cpr: get_cpr(journal_params["birthdate"])).first
		tokens = 
		if !journal
			survey_params = param["surveys"].map {|s| s.split("_")}.map {|e| {category: e.first, age: e.last} }
			surveys = survey_params.map {|s| Survey.where(s).first}
			service = JournalService.new
			journal, tokens = service.create_journal(center, journal_params, surveys, false)
			tokens
		else
			create_tokens(journal)
		end

		puts "tokens: #{tokens.inspect}"
		encrypted_tokens = encrypt_tokens(api_key, tokens) # tokens.inject({}) {|h,login| h[login.first] = api_key.lock(login.last.to_s); h }

		# TODO: Kristian vil gerne have et ID på journalen. Check hvad han mente (se papir)
		puts "New journal: #{journal.inspect}"
		puts "Tokens: #{tokens.inspect}  Encrypted tokens: #{encrypted_tokens.inspect}"
		render :text => "#{journal.title}: #{journal.birthdate}   #{encrypted_tokens.inspect}"
	end

	def open # login og åbne skema
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
        render :text => survey_start_path
		# render :text => "#{entry.journal.name} #{entry.survey.short_name}"		
	end

	
	def start

	end


	def index
		param = ActiveSupport::JSON.decode(request.raw_post)
		puts "param: #{param.class} #{param.inspect}"
		key = param["api_key"]

		puts "key: #{key}"
		# check api_key
		api_key = ApiKey.find_by_api_key(key)
		if api_key.nil?
			render :text => "Not found" and return
		end

		center = api_key.center
		response = center.journals.map {|j| {j.title => encrypt_tokens(api_key, create_tokens(j))}}.join("<br/>")
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

	def create_tokens(journal)
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

end