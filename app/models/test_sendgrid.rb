class TestSendgrid < Task

	def run
		self.letter.insert_text_variables(self.journal)

		settings = CenterSetting.find_by_center_id_and_name(self.journal.center_id, "follow_up_mail-from")
		puts "Could not find CenterSetting 'follow_up_mail'. You need to set mail from address" if settings.nil?
		from = settings && settings.value || "tina.ravn@rsyd.dk"

		puts "Sending letter to #{self.email} from #{from}"

		SendFollowUpMailer.test("Hello Test", "stamppot+sendgrid@gmail.com", "stamppot@gmail.com").deliver
	end

	def self.run_tasks
		puts "Running all TestSendgrid tasks"		
		TestSendgrid.new.run
	end

end
