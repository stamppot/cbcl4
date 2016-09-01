class CheckIfSendFollowUpLetterTask < Task

	belongs_to :journal

	attr_accessible :journal_id


	def self.create_task(journal)
		# only do this for team SAFARI
		if journal.group.title == "SAFARI"
			self.create :journal_id => journal.id, :group_id => journal.group_id
		end
	end

	def run
		c = ChooseLetterRule.new
		letter = c.choose_letter(journal, follow_up = 1)

		if letter
			email = journal.parent_email
			# what if no email has been registered?
			if email.blank?
				puts "Journal #{journal.id} #{journal.title} has no email. Task logged."
				TaskLog.create :task_id => self.id, :name => 'CheckIfSendFollowUpLetterTask', :message => "Journal has no parent_email",
					:journal_id => journal.id, :group_id => journal.group_id, :param1 => 'parent_email', :param2 => journal.parent_email
				# self.status = "Failed"
				self.save
				return
			end
			# TODO: check if email is valid
			task = SendLetterFollowUpTask.create :letter => letter, :email => email, :journal_id => journal.id, :group_id => journal.group_id
			puts "SendLetterFollowUpTask created: #{task.inspect}"
			self.completed!
		else
			puts "No letter defined for follow up. Center: #{journal.group.id} #{journal.group.title}"
			# self.no_action!
		end

		self.save
	end


	def self.run_tasks
		# group these since we don't want to send multiple letters to the same journals
		puts "Running all CheckIfSendFollowUpLetter tasks"		
		by_journal = CheckIfSendFollowUpLetterTask.where(:status => "#{self.todo_status}").inject({}) do |col, task|
			col[task.journal_id] ||= []
			col[task.journal_id] << task
			col
		end

		by_journal.each do |journal_id, tasks|
			tasks.first.run # run first, set rest to completed
			tasks.each { |task| task.completed!; task.save }
		end
	end
end