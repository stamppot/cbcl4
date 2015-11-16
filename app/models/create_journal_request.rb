class CreateJournalRequest 
	include ActiveModel::Model

	attr_accessor :api_key, :journal, :surveys

	# req = CreateJournalRequest.new(ApiKey.first.api_key, "Test Testesen", ["CBCL_6-16","TRF_6-16"])

	def initialize(api_key, journal, surveys)
		@api_key = api_key
		@journal = journal
		@surveys = surveys
	end

end