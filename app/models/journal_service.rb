class JournalService

	# gets or creates journal, then adds new entries
	def create_journal(center, journal_params, surveys, follow_up = 0, save = true)
		title = journal_params[:name] || journal_params["name"]
		birthdate = journal_params[:birthdate] || journal_params["birthdate"]
		puts "title: #{title} birthdate: #{birthdate} journal_params: #{journal_params.inspect}"
		journal = Journal.where(center_id: center.id, title: title, cpr: get_cpr(birthdate)).first

		if !journal
			puts "create_journal #{journal_params.inspect}"
			date = DateTime.parse(birthdate)
			puts "birthdate: #{date.inspect}"
			gender = journal_params[:gender] || journal_params["gender"]

			journal = Journal.new(title: title, sex: Journal.sexes[gender], birthdate: date, 
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
				# !journal.not_answered_entries.any? {|e| e.survey_id == survey.id }
				!journal.journal_entries.any? {|e| e.survey_id == survey.id && e.follow_up == follow_up }
			end
		end

		entries = journal.add_journal_entries(surveys, follow_up = 0, save)
		logins = entries.inject({}) do |col,e|
	    	col[e.survey.short_name] = {"login" => e.login_user.login, "password" => e.password}
		    col
		end
	    
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

	# shows per journal (with alt_id) which surveys have been answered when
	def show_answered_surveys(journals, conditions = {:follow_up => 1})
		journals.map {|j| [j.alt_id, j.title, j.answered_entries.where(conditions).map {|e| [e.survey.short_name, e.updated_at.to_s(:long)] }.sort ]}.sort_by &:first
	end
end
