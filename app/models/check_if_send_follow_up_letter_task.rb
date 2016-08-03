class CheckIfSendFollowUpLetterTask < Task

	belongs_to :journal

	attr_accessible :journal_id


	def self.create_task(journal)
		# only do this for team SAFARI
		if journal.group.title == "SAFARI"
			self.create :journal_id => journal.id
		end
	end

	def run
		c = ChooseLetterRule.new
		letter = c.choose_letter(journal, follow_up = 1)

		if letter
			email = journal.parent_email
			# what if no email has been registered?
			if email.blank?
				TaskLog.create :task_id => self.id, :name => 'CheckIfSendFollowUpLetterTask', :message => "Journal has no parent_email",
					:journal_id => journal.id, :group_id => journal.group_id, :param1 => 'parent_email', :param2 => journal.parent_email
				self.status = "Failed"
				self.save
				return
			end
			# TODO: check if email is valid
			task = SendLetterFollowUpTask.create :letter => letter, :email => email, :journal_id => journal.id
			puts "SendLetterFollowUpTask created: #{task.inspect}"
			self.status = "Completed"
			self.save
		end
	end

end