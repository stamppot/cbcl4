class MailingEntry < ActiveRecord::Base

	belongs_to :mailing
	attr_accessible :journal_id, :added_on, :problematic, :is_sent
end