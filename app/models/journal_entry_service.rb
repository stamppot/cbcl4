class JournalEntryService

	def connect_entries(entries, couple, do_save) 
		couple.each do |k,v|
			src = entries.select {|e| e.survey_id == k}.first
			dst = entries.select {|e| e.survey_id == v}.first
			raise "EntryNotFound: #{entries.to_a.inspect}  couple: #{couple.inspect}" unless dst
			src.next = dst.id
			src.save if do_save
		end
	end

	def connect(journal, couple, do_save) 
		couple.each do |k,v|
			src = journal.not_answered_entries.select {|e| e.survey_id == k}.first
			dst = journal.not_answered_entries.select {|e| e.survey_id == v}.first
			src.next = dst.id
			src.save if do_save
		end
	end
end