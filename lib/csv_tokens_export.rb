
# this class doesn't create a token export yet, it just adds data to an existing CSV with tokens

class CsvTokensExport


	def load(file)
		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{i} #{row}"
			next if row.blank?

			alt_id = row["alt_id"] 
			skema1 = row["skema1"]
			token1 = row["logintoken1"]
			skema2 = row["skema2"]
			token2 = row["logintoken2"]
			skema3 = row["Column1"]
			token3 = row["_1"]

			journals = Journal.where(:alt_id => alt_id)
			# det virker ikke, vi faar to resultater for tvillinger, men ved stadig ikke hvem der hoerer til hvad
		end
	end


		# assumes headers: ["alt_id", "id", "tvilling", "skema1", "logintoken1", "skema1", "logintoken2", "skema3", "logintoken3"]
	def export_login_tokens(journal, api_key = "13ccb7d0d0347440e7d62aa5a148f583") 

		ap = ApiKey.find_by_key "16bbc1a0e0127770e7d62bb5a148a783"

		tokens = ApiKey.to_id_with_tokens(journal)
		encrypted_tokens = encrypt_tokens(ap, tokens)
		 
		[tokens, encrypted_tokens]
	end

end