class TaskLog < ActiveRecord::Base

	belongs_to :task

	attr_accessible :name, :message, :group_id, :journal_id, :param1, :param2, :task_id

end