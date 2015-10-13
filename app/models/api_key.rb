class ApiKey < ActiveRecord::Base
	
	belongs_to :center
	
	attr_accessible :center_id, :name

	def self.calculate(str)
		Digest::MD5.hexdigest(str + 1.to_s + self.salt)
	end

	private

	def self.salt
		"8529defdef1028079ba6abcad178600c05b820a8"
	end

end