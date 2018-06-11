class ChainInfoSurvey


	def create_chain?(journal, survey, follow_up)
		puts "create_chain?  follow_up: #{follow_up},  journal: #{journal.inspect}, survey: #{survey.inspect}  center: #{journal.center_id}"
		return false unless journal.center_id == 1 || journal.center_id == 52 || journal.center_id == 9754 || journal.center_id == 9753 || journal.center_id == 9755 || journal.center_id == 8888 # BPUH, Testcenter
		puts "center is bpuh"
		return false unless follow_up.to_i == 0
		return false if (survey.id == 10 || survey.id == 210) && journal.age >= 18 && journal.center_id == 1
		
		puts "follow_up is 0"
		exists = journal.surveys.any? { |s| s.id == 10 || s.id == 210 }
		puts "exists: #{exists}"
		#return false if exists
		#puts "surveys doesn't exist already"
		return false unless survey.surveytype == "parent"
		puts "surveytype is parent"
		return true
	end

	def create_chain(journal, surveys, follow_up)
		puts "create_chain: journal: #{journal.inspect}, surveys: #{surveys.inspect}, follow_up: #{follow_up}"
		survey = surveys.select {|s| s.surveytype == "parent"}.first

		puts "found parent survey: #{survey.inspect}"
		is_valid = survey && create_chain?(journal, survey, follow_up)
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
end
