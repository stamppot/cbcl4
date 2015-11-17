class JournalService

	def create_journal(center, journal_params, surveys, save = true)
		journal = Journal.where(center_id: center.id, title: journal_params["name"], cpr: get_cpr(journal_params["birthdate"])).first

		if !journal
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
			surveys = surveys.select do |survey|
				!journal.not_answered_entries.any? {|e| e.survey_id == survey.id }
			end
		end

		entries = journal.create_journal_entries(surveys, follow_up = 0, save)
		logins = entries.inject({}) do |col,e|
	    	col[e.survey.short_name] = {"login" => e.login_user.login, "password" => e.password}
		    col
		end
	    
	    return [journal, logins]
	end

	def get_cpr(date_str)
    	dato = date_str.split("-")
    	dato[0] = dato[0][2..3]
    	dato.reverse.join
	end

end