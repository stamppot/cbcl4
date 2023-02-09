class ChainInfoSurvey

	def create_chain(journal, surveys, follow_up)
		if create_chain_buph?(journal, surveys, follow_up)
			create_chain_buph(journal, surveys, follow_up)
		elsif create_chain_bupeav?(journal, surveys, follow_up)
			create_chain_bupeav(journal, surveys, follow_up)
		else
			puts "do not create chain"
		end
	end

	# Forskningsenheden, Børne- og Ungdomspsykiatri Odense
	def create_chain_buph(journal, surveys, follow_up)
		survey = surveys.select {|s| s.surveytype == "parent"}.first

		puts "found parent survey: #{survey.inspect}"
		is_valid = survey && create_chain_buph?(journal, surveys, follow_up)
		puts "do create_chain #{is_valid.inspect}"

		if is_valid
			info_surveys = [] << Survey.find(210)
			couple = {survey.id => info_surveys.first.id}
			puts "couple: #{couple.inspect}"
			entries = journal.add_journal_entries(info_surveys, follow_up, true)
			puts "entries to couple: #{entries.inspect}"
			JournalEntryService.new.connect(journal, couple, true)
			# logger.info "Created chain: #{couple}, journal: #{journal.inspect}"
			puts "Created chain: #{couple}, journal: #{journal.inspect}"
		end
	end

	def create_chain_buph?(journal, surveys, follow_up)
		survey = surveys.select {|s| s.surveytype == "parent"}.first
		puts "create_chain?  follow_up: #{follow_up},  journal: #{journal.inspect}, survey: #{survey.inspect}  center: #{journal.center_id}"
		return false unless journal.center_id == 1 || journal.center_id == 52 || journal.center_id == 9754 || journal.center_id == 9753 || journal.center_id == 9755 || journal.center_id == 8888 # BPUH, Testcenter
		puts "center is bpuh"
		return false unless follow_up.to_i == 0
		return false if (survey.id == 10 || survey.id == 210) && journal.age >= 18 && journal.center_id == 1
		
		puts "follow_up is 0"
		exists = journal.surveys.any? { |s| s.id == 10 || s.id == 210 }
		puts "exists: #{exists}"
		return false unless survey.surveytype == "parent"
		puts "surveytype is parent"
		return true
	end


	# Børne- og Ungdomspsykiatri Esbjerg, Aabenraa, Vejle
	def create_chain_bupeav?(journal, surveys, follow_up) # Børne- og Ungdomspsykiatri Esbjerg, Aabenraa, Vejle
		return false unless journal.center_id == 14060 || journal.center_id == 14050 || journal.center_id == 14065  # BPUH, Testcenter
		return true
	end

	def create_chain_bupeav(journal, surveys, follow_up)
		#logger.info "create_chain_bupeav: journal: #{journal.inspect}, surveys: #{surveys.inspect}, follow_up: #{follow_up}"
		age = journal.age

		surveys.each do |survey|

			puts "curr survey: #{survey.inspect}"
			is_valid = survey && create_chain_bupeav?(journal, survey, follow_up)
			puts "do create_chain #{is_valid.inspect}"

			if is_valid
				info_surveys = 
				case survey.id
				when 1
				     [Survey.find(210)]   # CBCL børn forældre
				when 2
				 	age >= 6 && [Survey.find(210)] || []   # CBCL 6-16 parent, age check was >= 11
				when 3
				 	[]   # C-TRF pædagog
				when 4
				 	[]   # TRF teacher 
				when 5
				  	[]   # ingen kobling [Survey.find(11)]   # YSR youth
				else
				 	[]
				end
				couple = info_surveys.any? && {survey.id => info_surveys.first.id} || {}
				puts "couple: #{couple.inspect}"
				entries = journal.add_journal_entries(info_surveys, follow_up, true)
				#logger.info "entries to couple: #{entries.inspect}"
				JournalEntryService.new.connect(journal, couple, true) if couple.any?
				# logger.info "Created chain: #{couple}, journal: #{journal.inspect}"
				puts "Created chain: #{couple}, journal: #{journal.inspect}"
			end
		end
	end

end
