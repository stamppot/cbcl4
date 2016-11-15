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
		self.letter.insert_text_variables(self.letter.to_text_variables(self.journal))

		mail_from_setting = CenterSetting.find_by_center_id_and_name(self.journal.center_id, "follow_up_mail-from")
		puts "Could not find CenterSetting 'follow_up_mail'. You need to set mail from address" if mail_from_setting.nil?
		from = mail_from_setting && mail_from_setting.value || "tina.ravn@rsyd.dk"

		puts "Sending letter to #{self.email} from #{from}"

		mailing_enabled = CenterSetting.enabled?(self.journal.center_id, "enable_send_mails")

		if !mailing_enabled
			puts "DISABLED: SendLetterFollowUpTask. Check CenterSetting 'enable_send_mails'"
			return
		end

		SendFollowUpMailer.send_follow_up_letter(self.letter.letter, self.journal.parent_email, from).deliver

		TaskLog.create :name => 'SendLetterFollowUpTask', 
			:message => "Sent follow_up email #{self.email}", 
			:param1 => self.journal.parent_email,
			:journal_id => self.journal_id,
			:group_id => self.journal.group_id,
			:task_id => self.id,
			:param2 => self.letter.id

		if true #true  # TODO: actually send mail and set this task to 'Completed'
			self = "Completed"
			self.save
		end
	end

	def self.already_got_letter?(journal)
		SendLetterFollowUpTask.where(:journal_id => journal.id).any?
	end

	def self.run_tasks
		puts "Running all SendLetterFollowUp tasks (approved more than two hours ago)"
		SendLetterFollowUpTask.where('status = ? AND updated_at < ?', self.approved_status, 2.hours.ago).each {|task| task.run }
	end


	def self.count_failed
		SendLetterFollowUpTask.with_journal.with_status(failed_status).count
	end
end
