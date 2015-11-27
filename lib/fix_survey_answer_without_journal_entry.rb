class FixSurveyAnswerWithoutJournalEntry

	def fix
		rows = find_broken
	    # puts "rows: #{rows.inspect}"

	    orphans = []

	    rows.each do |row|
	    	# find entry of type surveytype, age between
	    	journal_id = row["journal_id"]
	    	j = Journal.find journal_id
			
			if !j
				puts "Journal not found: #{journal_id}"
				next
			end

	    	entries = find_answered_entry(j, row["survey_id"], row["follow_up"])
	    	puts "found: #{entries.size} #{entries.inspect}"

	    	if entries.size == 0
	    		# orphans << row
	    		puts "No answered entries found, orphan survey_answers"
	    	end

	    	entries = find_unanswered_entry(j, row["survey_id"], row["follow_up"])

	    	if entries.size == 0
	    		orphans << row
	    		puts "No unanswered entries found, orphan survey_answers"
	    	elsif entries.size == 1  # good, we can fix them
	    		puts "answered_entries: #{j.answered_entries.size} #{j.answered_entries.inspect}"
	    		entry = entries.first
	    		survey_answer = SurveyAnswer.find row["survey_answer_id"]
	    		# puts "survey_answer: #{survey_answer.inspect}"
	    		survey_answer.journal_entry_id = entry.id
	    		survey_answer.save
	    		j = survey_answer.journal_entry_id
	    		j.survey_answer_id = survey_answer.id
	    		j.answered!
	    	else
	    		puts "found more than one entry for #{j.inspect} "
	    	end
	    end

	    puts "orphans: #{orphans.size} #{orphans.inspect}"

	    rows
	end

	def find_broken
		query = "select j.id as journal_id, j.title, j.code, j.group_id, g.title, j.center_id, s.category, s.id as survey_id, s.age, s.surveytype, sa.id as survey_answer_id, sa.follow_up, sa.created_at, sa.updated_at from survey_answers sa
			inner join journals j on j.id = sa.journal_id
			inner join surveys s on s.id = sa.survey_id and s.surveytype = sa.surveytype
			inner join groups g on g.id = j.group_id
			where journal_entry_id = 0"

		rows = 
	    ActiveRecord::Base.connection.execute(query).each(:as => :hash).inject([]) do |col,r|
	      # puts r.inspect
    		col << r
      		col
	    end
	end

	def find_answered_entry(journal_id, survey_id, follow_up)
		if j
			j.answered_entries.select {|je| je.survey_id == survey_id && je.follow_up == follow_up }
		else
			puts "Journal not found: #{journal_id}"
			[]
		end
	end

	def find_unanswered_entry(journal_id, survey_id, follow_up)
		if j
			j.not_answered_entries.select {|je| je.survey_id == survey_id && je.follow_up == follow_up }
		else
			puts "Journal not found: #{journal_id}"
			[]
		end
	end

end