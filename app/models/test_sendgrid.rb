class TestSendgrid < Task

	def self.run
		puts "Sending letter to #{self.email} from #{from}"

		SendFollowUpMailer.test("Hello Test", "stamppot+sendgrid@gmail.com", "stamppot@gmail.com").deliver
	end

end
