class ChainInfoSurvey


	def create_chain?(journal, survey, follow_up)

		return if !journal.center == 1 # BPUH
		return if !follow_up == 0

		exists = journal.surveys.any? { |s| s.id == 10 }
		return if exists

		return if !survey.surveytype == "parent"

		return true
	end

	def create_chain(journal, entries, follow_up)

		entry = entries.select {|s| s.survey.surveytype == "parent"}.first
		if entry && create_chain?(journal, entry.survey, follow_up)
			surveys = [] << Survey.find(10)
			entries = journal.add_journal_entries(surveys, couple, true)

			couple = {surveys.first.id => entry.survey.id}

			JournalEntryService.new.connect(journal, couple, true)
			logger.info "Created chain: #{couple}, journal: #{journal.inspect}"
		end
	end
end