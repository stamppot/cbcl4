class ArchiveLettersTask < Task

#	belongs_to :letter
#	belongs_to :journal

	attr_accessible :group_id

	def run
		self.archived!
		self.save
	end

	def self.run_tasks
		settings = CenterSetting.find_by_center_id_and_name(self.journal.center_id, "archive_letters_older_than_days")
		puts "Could not find CenterSetting 'archive_letters_older_than_days'." if settings.nil?
		days = (settings && settings.value || "30").to_i

		puts "Archiving completed letters older than #{days} days"

		TaskLog.create :name => 'ArchiveLettersTask', 
			:message => "Archived letters #{DateTime.now.to_s(:long)}", 
			:task_id => self.id

		SendLetterFollowUpTask.where(:status => self.completed_status)
							  .where("updated_at < ?", days.days.ago)
							  .each {|task| task.run }
	end

end
