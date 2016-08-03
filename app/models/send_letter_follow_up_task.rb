class SendLetterFollowUpTask < Task

	belongs_to :letter

	attr_accessible :email

	def email
		self.param1
	end

	def email=(value)
		self.param1 = value
	end
end