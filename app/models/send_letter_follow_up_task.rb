class SendLetterFollowUpTask < Task

	belongs_to :letter

	attr_accessible :email, :letter, :journal_id


	def email
		self.param1
	end

	def email=(value)
		self.param1 = value
	end

	def run
		# TODO: send mail with some service
		# get configuration somewhere (mailfrom, mailserver, etc)

		TaskLog.create :name => 'SendLetterFollowUpTask', 
			:message => 'Test: sent email', 
			:param1 => self.email,
			:journal_id => self.journal_id, :task_id => self.task_id

		if true
			self.status.completed!
			self.save
		end
	end

	def self.run_tasks
		puts "Running all SendLetterFollowUp sasks"		
		SendLetterFollowUpTask.where(:status => "#{self.todo_status}").each {|task| task.run }
	end
end