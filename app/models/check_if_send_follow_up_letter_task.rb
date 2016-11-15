class CheckIfSendFollowUpLetterTask < Task

	belongs_to :journal

	attr_accessible :journal_id, :group_id


	def self.create_task(journal)
		# only do this for team SAFARI
		if journal.group.title == "SAFARI"
			CheckIfSendFollowUpLetterTask.create :journal_id => journal.id, :group_id => journal.group_id
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
			task = SendLetterFollowUpTask.create :letter => letter, :email => email, :journal_id => journal.id, :group_id => journal.group_id
			puts "SendLetterFollowUpTask created: #{task.inspect}"
			self.status = "Completed"
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
			tasks.each { |task| task = "Completed"; task.save }
		end
	end

	def self.already_sent_letter?(journal)
		SendLetterFollowUpTask.where(:journal_id => journal.id).any?
	end

	def self.check_if_send_follow_up_letter(journal, send_letter = false)
		# only do this for team SAFARI
		return unless journal.group.title == "SAFARI"

		need_letter = !self.already_sent_letter?(journal) && 
			journal.survey_answers_answered?(follow_up = 1, surveys = [1,3,9])
		
		if need_letter && send_letter
			self.create_task(journal)
		end

		need_letter
	end

	def self.find_all_need_letter(team_id = 9259)
		journals = Team.find(9259).journals
		journals.select { |j| !self.already_sent_letter?(j) && j.survey_answers_answered?(follow_up = 1, surveys = [1,3,9]) }

	end

	def self.check_all(team_id = 9259, send_letter = false)
		team = Team.find team_id
		team.journals.each { |j| self.check_if_send_follow_up_letter(j, send_letter) }
	end
end