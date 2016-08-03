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

		if succes = true
			self.status = "Completed"
			self.save
		end
	end
end