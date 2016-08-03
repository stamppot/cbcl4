class SurveyUsageLog < ActiveRecord::Base

	attr_accessible :survey_id, :user_id, :group_id, :center_id, :survey_answer_id

	def self.create_log(entry, user)
		self.create(:survey_id = entry.survey_id, :user_id => user.id, 
			:group_id => entry.group_id, :center_id => user.center_id, :survey_answer_id => entry.survey_answer_id)
	end
end