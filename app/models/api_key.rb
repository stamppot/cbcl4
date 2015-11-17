
class ApiKey < ActiveRecord::Base
	require 'aescrypt'
	include AESCrypt
	
	belongs_to :center

	attr_accessible :center_id, :name

	def self.calculate(str)
		Digest::MD5.hexdigest(str + 1.to_s + self.salt)
	end

	def get_salt
		salt + ApiKey.salt
	end

	def lock(data)
		# Base64.strict_encode64(
		CGI::escape(
			AESCrypt::encrypt(data, salt + self.salt)
		)
			# )
	end

	def unlock(data)
		AESCrypt::decrypt(CGI::unescape(data), salt + self.salt)
	end


	private

	def self.salt
		"8529defdef1028079ba6abcad178600c05b820a8"
	end


end