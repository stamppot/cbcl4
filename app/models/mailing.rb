class Mailing < ActiveRecord::Base
	audited
	has_many :mailing_entries
# flere breve
	attr_accessible :name, :letter_id, :created_at, :follow_up, :center_id, :group_id, :status, :sent_on

end