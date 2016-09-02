class SendLetterFollowUpTask < Task

	belongs_to :letter
	belongs_to :journal

	attr_accessible :email, :letter, :journal_id, :group_id


	def email
		self.param1
	end

	def email=(value)
		self.param1 = value
	end

	def run
		# TODO: send mail with some service
		# get configuration somewhere (mailfrom, mailserver, etc)

		# letter = FollowUpLetter.where(:group_id => self.journal.group_id, :problematic => self.letter).first
		self.letter.insert_text_variables(self.journal)

		TaskLog.create :name => 'SendLetterFollowUpTask', 
			:message => 'Test: sent email', 
			:param1 => self.email,
			:journal_id => self.journal_id,
			# :group_id => self.group_id
			:task_id => self.id

		if false #true
			self.status.completed!
			self.save
		end
	end

	def self.run_tasks
		puts "Running all SendLetterFollowUp sasks"		
		SendLetterFollowUpTask.where(:status => "#{self.todo_status}").each {|task| task.run }
	end


	def self.count_failed
		SendLetterFollowUpTask.with_journal.with_status(failed_status).count
	end
end