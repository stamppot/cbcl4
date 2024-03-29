
class ApiKey < ActiveRecord::Base
	require 'aescrypt'
	include AESCrypt
	
	belongs_to :center

	attr_accessible :center_id, :name

	def self.calculate(str)
		Digest::MD5.hexdigest(str + 1.to_s + self.salt)
	end

	def get_salt
		salt + ApiKey.salt
	end

	def lock(data) Base64.urlsafe_encode64(AESCrypt::encrypt(data, salt + self.salt)) unless data.blank? end

	def unlock(data)
		AESCrypt::decrypt(
			#CGI::unescape(
			Base64.urlsafe_decode64(
			data
			), salt + self.salt)
	end


	### params   (for CBCL/safari: 16bbc1a0e0127770e7d62bb5a148a783)
	## key: "13ccb7d0d0347440e7d62aa5a148f583"
	# journal_params: {"name":"Test T", "gender":"f", "birthdate":"2015-10-15"}
# {"api_key":"13ccb7d0d0347440e7d62aa5a148f583","journal":{"name":"Test Testesen","gender":"f","birthdate":"2015-10-15"},
#  "surveys":["CBCL_6-16", "TRF_6-16"],"follow_up":0}
	def self.create(key, journal_params, surveys, follow_up = 0, save = true)
		api_key = ApiKey.find_by_api_key(key)
		if api_key.nil?
			return {:success => false, :text => "Not found"}
		end

		center = Center.find(api_key.center_id)
		return {:text => "Error: invalid api_key (no center)"} if !center

		follow_up = follow_up && follow_up.to_i || 0  # works only for follow_up: Diagnose
		survey_params = surveys.map {|s| s.split("_")}.map {|e| {category: e.first, age: e.last} }
		surveys = survey_params.map {|s| Survey.where(s).first}
		service = JournalService.new
		journal, tokens = service.create_journal(center, journal_params, surveys, follow_up, true)
		puts "new journal: #{journal.inspect} tokens: #{tokens.inspect}"
		tokens

		if !tokens.any?
			puts "existing journal: #{journal.inspect}"
			tokens = self.to_token(journal)

			if !tokens.any?
				return {:text => [journal.title, {:result => 0, :message => 'No surveys created and logins created, already exists and answered'}]}
			end
		end

		puts "tokens: #{tokens.inspect}"
		encrypted_tokens = api_key.encrypt_tokens(api_key, tokens)
	end

	def encrypt_tokens(api_key, tokens)
		encrypted_tokens = tokens.inject({}) {|h,login| h[login.first] = api_key.lock(login.last.to_s); h }
	end

	# ap = ApiKey.second; res = []; Journal.where(:group_id => 9259).find_each(:batch_size => 500) do |j| res << ap.encrypt_token(ap, ApiKey.to_token(j)); end
# def ApiKey.to_token(journal) journal.not_answered_entries.inject({}) do |h, e| if(e.login_user); h[journal.alt_id] = journal.alt_id; h[e.survey.short_name] = {"id" => journal.alt_id, "navn" => journal.title, "login" => e.login_user.login, "password" => e.password}; end; h; end; end

	def ApiKey.to_token(journal)
		journal.not_answered_entries.inject({}) do |h, e| 
			if e.login_user
				h[journal.alt_id] = journal.alt_id 
				h[e.survey.short_name] = {"login" => e.login_user.login, "password" => e.password}
			end
			h
		end
	end

	def to_id_with_tokens(journal)
			entries = journal.not_answered_entries.inject({}) do |h, e| 
		  		if e.login_user
					h[e.survey.short_name] = lock({"login" => e.login_user.login, "password" => e.password}.to_s)
				end
				h
			end
																		if entries.any?
				entries["alt_id"] = journal.alt_id 
				entries["id"] = journal.code
				entries["tv"] = journal.title.include?("TVA") ? "TVA" : journal.title.include?("TVB") ? "TVB" : ""  
			end
		entries
	end

	def to_id_with_tokens_csv(journal) 
		tokens = to_id_with_tokens(journal)
		line = [] << tokens["alt_id"]
		line << tokens["id"] << tokens["tv"]
		line << tokens["CBCL_6-16"] << tokens["TRF_6-16"]
		line# .join(";")
	end

	def create_token(api_key, journal)
		tokens = ApiKey.to_token(journal)
		encrypted_tokens = tokens.inject({}) {|h,login| h[login.first] = api_key.lock(login.last.to_s); h }
		encrypted_tokens
	end

	
	def create_tokens_for_list(csv_file)
		journal_titles = CSV.read(csv_file)
		puts journal_titles
		journal_titles.delete "title"
		surveys = ["CBCL_6-16", "TRF_6-16"]
		journal_titles.inject({}) do |h, title|
			#next if title.first == "title"
			name = title.first
			#puts "name: #{name.inspect}" 
			puts journal_titles
			# j = Journal.find_by_title(title)
			j_params = {"name":name, "gender":"f", "birthdate":"2011-11-17"}
			#puts j_params
			token = ApiKey.create(self.api_key, j_params, surveys).compact
			puts "token: #{token.inspect}"
			next if name.nil? || token.nil?
			h[name] = token
			h
		end							
	end




	private

	def self.salt
		"8529defdef1028079ba6abcad178600c05b820a8"
	end


end
