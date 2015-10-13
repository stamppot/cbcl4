class JournalService

	def create_journal(center, journal_params, surveys)
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

		if journal.valid?
	    	entries = journal.create_journal_entries(surveys, 0, true)
	    	# journal.save && entries.map &:save
	    	api_key = ApiKey.find_by_center_id(center.id)
	    	logins = entries.inject({}) do |col,e|
	    	  col[e.survey.short_name] = {"login" => e.login_user.login, "password" => e.password}
	    	  col
	    	end
	    	return [journal, logins]
	    	# TODO: create tokens for each login
		else
			puts "ERRORS: #{journal.errors.inspect}"
			return [journal, {}]
		end 
	end
end