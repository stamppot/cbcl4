class MailingTrigger

	def get_answered
		# j = Journal.includes(:journal_entries).references(:journal_entries).P1(9259).P2(9259).P3(9259).P4(9259).
		j = Journal.includes(:journal_entries).references(:journal_entries)
				.in_group(9259)
				.answered(9259)
				.for_surveys([1,3,9])
				with_follow_up(1).group('journal_id')


				# get survey_answers with a score result in the 98th percentile
		 jj = SurveyAnswer.includes({:score_rapport => :score_results})
		 	.where('survey_answers.team_id' => 9259, :follow_up => 1, :survey_id => [1,3,9], 'score_results.percentile_98' => 1).group_by &:journal_id

		 jj = SurveyAnswer.includes({:score_rapport => :score_results})
		 	.where('survey_answers.team_id' => 9259)
		 	.where(:follow_up => 1)
		 	.where(:survey_id => [1,3,9])
		 	.where('score_results.percentile_98' => 1)
		 	.group_by &:journal_id

	end

end