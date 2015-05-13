class FixMissingJournalInfos

	def find_missing_journal_infos
		query = "select id from survey_answers where alt_id is null or alt_id = ''"

        result = ActiveRecord::Base.connection.select_all(query)
        missing = result.group_by {|c| c["id"] }.keys
   end


   def fix_missing_projekt_survey_answer(survey_answer_id)
   		sa = SurveyAnswer.find_by_id(survey_answer_id)
   		if sa.nil?
   			puts "Journal #{survey_answer_id} not found"
   			return
   		end
		sa.update_info
   	end

   	def fix_all_projekts
   		sas = find_missing_journal_infos
   		sas.each { |sa| fix_missing_projekt_survey_answer(sa) }
   	end
end