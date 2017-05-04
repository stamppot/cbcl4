class ChainInfoSurvey


	def create_chain?(journal, survey, follow_up)
		puts "create_chain?  follow_up: #{follow_up},  journal: #{journal.inspect}, survey: #{survey.inspect}  center: #{journal.center_id}"
		return false unless journal.center_id == 1 # BPUH
		puts "center is bpuh"
		return false unless follow_up.to_i == 0
		puts "follow_up is 0"
		exists = journal.surveys.any? { |s| s.id == 10 }
		puts "exists: #{exists}"
		return false if exists
		puts "surveys doesn't exist already"
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
			info_surveys = [] << Survey.find(10)
			couple = {info_surveys.first.id => survey.id}
			puts "couple: #{couple.inspect}"
			entries = journal.add_journal_entries(info_surveys, follow_up, true)
			puts "entries to couple: #{entries.inspect}"
			JournalEntryService.new.connect(journal, couple, true)
			# logger.info "Created chain: #{couple}, journal: #{journal.inspect}"
			puts "Created chain: #{couple}, journal: #{journal.inspect}"
		end
	end
end