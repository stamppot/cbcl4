class TestSendgrid < Task

	def self.run
		puts "Test sending email with SendGrid"

		SendFollowUpMailer.test("Hello Test", "stamppot+sendgrid@gmail.com", "stamppot@gmail.com").deliver
	end

end
