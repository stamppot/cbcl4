class ChooseLetterRule

	def get_answers(journal, follow_up)
		SurveyAnswer.where(:journal_id => journal.id, :done => 1, :follow_up => follow_up)
	end

	def all_three_answered?(survey_answers, surveys = [1,3,9])
		all_answered = survey_answers.map {|e| e.survey_id}.uniq.sort == surveys  # children surveys: CBCL, TRF, ASQ
		puts "all_three_answered? #{all_answered}"
		all_answered
	end

	def is_problematic_score?(survey_answer)
		if survey_answer.score_rapport.nil?
			survey_answer.score_rapport
		end
		survey_answer.score_rapport.has_98th_percentile_scores.any?
	end

	def is_problematic_letter?(survey_answers, follow_up = 1)
		problematic = survey_answers.map {|sa| is_problematic_score?(sa) }.any?
		puts "is_problematic_score? #{problematic}"
		problematic
	end

	def choose_letter(journal, follow_up = 1)
		entries = get_answers(journal, follow_up)
		must_have_letter = all_three_answered?(entries)
		return unless must_have_letter  # no letter, since all three haven't been answered

		is_problematic_letter = is_problematic_letter?(entries, follow_up)

		puts "is_problematic_score? #{is_problematic_letter}"
		l = FollowUpLetter.where(:group => journal.group, :follow_up => follow_up, :problematic => is_problematic_letter).first		
	end
end