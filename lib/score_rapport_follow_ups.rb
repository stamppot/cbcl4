class ScoreRapportFollowUps

	def update
		ScoreRapport.find_each(:batch_size => 100) do |sr|
			next if sr.survey_answer.nil? || sr.survey_answer.journal_entry.nil?
			sr.follow_up = sr.survey_answer.journal_entry.follow_up
			sr.save
		end
	end
end