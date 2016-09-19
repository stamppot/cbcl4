class ArchiveLettersTask < Task

#	belongs_to :letter
#	belongs_to :journal

	attr_accessible :group_id

	def run
	# TODO: find letters more than 1 month (read from CenterSetting) old which are completed. Set these to archived
	
		settings = CenterSetting.find_by_center_id_and_name(self.journal.center_id, "archive_letters_older_than_days")
		puts "Could not find CenterSetting 'archive_letters_older_than_days'." if settings.nil?
		days = (settings && settings.value || "30").to_i

		puts "Archiving completed letters older than #{days} days"

		TaskLog.create :name => 'ArchiveLettersTask', 
			:message => "Archived letters #{DateTime.now.to_s(:long)}", 
			:task_id => self.id
		
		self.archived!
		self.save
	end

	def self.run_tasks
		puts "Running all SendLetterFollowUp tasks"		
		SendLetterFollowUpTask.where("status = '#{self.completed_status}' AND 'updated_at' < '#{days.days.ago}').each {|task| task.run }
	end

end
