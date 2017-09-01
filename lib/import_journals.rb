require 'rubygems'
require 'csv'

class ImportJournals # AddJournalsFromCsv

    # when 1 then "cc"  # cbcl 1,5-5 # change
    # when 2 then "ccy" # CBCL 6-16
    # when 3 then "ct"  # CTRF pædagog 1,5-5
    # when 4 then "tt"  # TRF lærer 6-16
    # when 5 then "ycy" # YSR 6-16
    
    def initialize
    	list
    end
 	
 	def update_followup(file, do_save = false, survey_ids = [1,3,9], team_id = 9259, follow_up = 1, couple = {1 => 9})
 		update file, survey_ids, team_id, follow_up, couple, do_save
 	end

 		# do_next couples journal_entries so one survey can be answered after the other without logging out/in
	def update(file, survey_ids, team_id, follow_up = 0, couple = {}, do_save = false)
		puts "no survey_ids given" and return if !survey_ids.any?
		puts "invalid follow_up: #{follow_up}" and return if follow_up.to_i < 0
		puts "invalid coupling: #{couple.inspect}" and return if !couple.is_a?(Hash)
		
		surveys = Survey.find(survey_ids)
		group = Group.find(team_id)
		center = group.center

		i = 1
		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{i} #{row}"
			next if row.blank?

			alt_id = row["alt_id"] || row["Graviditetsid"]
			b = row["birthdate"]
			journal_name = row["journalnavn"] || row["Bnavn"] || row["Navn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"] || row["Gender"]
			sex = sex == "d" || sex == "M" || sex == "1" || sex == "Dreng" && 1 || 2

			puts "#{journal_name}: #{alt_id} #{b}  sex: #{sex}"
			# next

			has_twins = Journal.where(:alt_id => alt_id, :group_id => 9259).count > 1

			journal = Journal.find_by_alt_id_and_group_id(alt_id, team_id)
			if has_twins
				puts "TWINS: #{journal_name} #{alt_id}"
				journal = Journal.find_by_alt_id_and_title_and_group_id(alt_id, journal_name, team_id)
				if journal.nil?
					puts "Could not find twin, check name: #{journal_name}"
					raise "journal error"
				end
			end

			birthdate = b && get_date(b) || journal.birthdate

			if birthdate.blank?
				puts "ERROR: no birthdate: #{row}"
				next
			end

			raise "DateError: #{birthdate} row: #{row.inspect}" if birthdate.year < 1980

			puts "birthdate: #{birthdate}"
			args = {
				:title => journal_name, :group_id => group.id, :center_id => group.center_id,
				:birthdate => birthdate, :parent_email => parent_mail,
				:parent_name => parent_name, :alt_id => alt_id, :nationality => "Dansk", :sex => sex
			}
			journal.sex = sex if journal
			journal.update_attributes(args) if journal

			if !journal
				args[:code] = center.next_journal_code
				journal = Journal.new(args)
				puts journal.errors.inspect if !journal.valid?
				if do_save
					journal.save
					puts "Saved journal: #{journal.id}  #{journal.title}"
				end
			else
				journal.title = args[:title]
				journal.parent_email = args[:parent_mail]
				journal.birthdate = args[:birthdate]
				if do_save
					journal.save
					puts "Saved journal: #{journal.id}  #{journal.title}"
				end
			end
			
			new_entries = add_surveys_and_entries(journal, surveys, follow_up, do_save)
			puts "GOT entries: #{new_entries.inspect}"
			connect_entries(new_entries, couple, do_save) unless couple.blank? && do_save

			i = i + 1
		end

		update_email(file, team_id, do_save)
	end

 		# update parent_email
 	def list
    	puts "update(file, [survey_ids], team_id, follow_up, {couple}, do_save)"
    	puts "update_followup(file, do_save = false, survey_ids = [1,3,9], team_id = 9259, follow_up = 1, couple = {1 => 9}"
 		puts "update_email(file, team_id, do_save = false)  update info"
 		puts "update_emails(file, team_id, do_save = false) update only emails"
 		puts "check_next(file = 'aug_2010.csv', team_id = 9259)"
 		puts "update(file, survey_ids, team_id, follow_up = 0, couple = {}, do_save = false)"
 		puts "update_connect(file, team_id, couple = {}, do_save = false)"
 		puts "fix_twin_email(team_id = 9259)"
 	end

	def update_email(file, team_id = 9259, do_save = false)
		group = Group.find(team_id)
		center = group.center

		i = 1
		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{i} #{row}"
			next if row.blank?

			alt_id = row["alt_id"] || row["Graviditetsid"]
			b = row["birthdate"]
			journal_name = row["journalnavn"] || row["Bnavn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"] || row["Gender"]
			sex = sex == "d" || sex == "M" || sex == "1" || sex == "Dreng" && 1 || 2

			puts "#{journal_name}: #{alt_id} #{b}  sex: #{sex}  email: #{parent_mail}    mor: #{parent_name}"

			journal = Journal.find_by_alt_id_and_title_and_group_id(alt_id, journal_name, team_id)

			next unless journal
			
			if parent_mail.blank?
				puts "parent email is blank: #{parent_mail}"
			end

			if !parent_mail.blank? && !EmailValidator.new.valid?(parent_mail)
				puts "parent email is not valid: '#{parent_mail}'' #{journal.inspect}"
				raise "InvalidEmailError: #{parent_mail}"
			end
			
			birthdate = b && get_date(b) || journal.birthdate

			raise "DateError: #{birthdate} row: #{row.inspect}" if birthdate.year < 1980

			puts "birthdate: #{birthdate}"
			args = {
				:title => journal_name, :group_id => group.id, :center_id => group.center_id,
				:birthdate => birthdate, :parent_email => parent_mail,
				:parent_name => parent_name, :alt_id => alt_id, :nationality => "Dansk", :sex => sex
			}
			journal.parent_email = parent_mail
			puts "valid?  #{journal.valid?}"
			journal.save if do_save
			
			i = i + 1
		end
	end

	def update_emails(file, team_id = 9259, do_save = false)
		group = Group.find(team_id)
		center = group.center

		i = 1
		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{i} #{row}"
			next if row.blank?

			alt_id = row["alt_id"] || row["Graviditetsid"]
			b = row["birthdate"]
			journal_name = row["journalnavn"] || row["Bnavn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"] || row["Gender"]
			sex = sex == "d" || sex == "M" || sex == "1" || sex == "Dreng" && 1 || 2

			puts "#{journal_name}: #{alt_id} #{b}  sex: #{sex}  email: #{parent_mail}    mor: #{parent_name}"

			journal = Journal.find_by_alt_id_and_title_and_group_id(alt_id, journal_name, team_id)

			puts "found journal: #{journal.inspect}"
			next unless journal
			
			if parent_mail.blank?
				puts "parent email is blank: #{parent_mail}"
			end

			if !parent_mail.blank? && !EmailValidator.new.valid?(parent_mail)
				puts "parent email is not valid: '#{parent_mail}'' #{journal.inspect}"
				raise "InvalidEmailError: #{parent_mail}"
			end
			
			# birthdate = b && get_date(b) || journal.birthdate

			# raise "DateError: #{birthdate} row: #{row.inspect}" if birthdate.year < 1980

			# puts "birthdate: #{birthdate}"
			# args = {
			# 	:title => journal_name, :group_id => group.id, :center_id => group.center_id,
			# 	:birthdate => birthdate, :parent_email => parent_mail,
			# 	:parent_name => parent_name, :alt_id => alt_id, :nationality => "Dansk", :sex => sex
			# }
			journal.parent_email = parent_mail
			puts "valid?  #{journal.valid?}"
			journal.save if do_save
			
			i = i + 1
		end
	end
	def update_connect(file, team_id = 9259, follow_up = 1, couple = {1 => 9}, do_save = false)
		group = Group.find(team_id)
		center = group.center

		i = 1
		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{i} #{row}"
			next if row.blank?

			alt_id = row["alt_id"] || row["Graviditetsid"]
			b = row["birthdate"]
			journal_name = row["journalnavn"] || row["Bnavn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"] || row["Gender"]
			sex = sex == "d" || sex == "M" || sex == "1" || sex == "Dreng" && 1 || 2

			puts "#{journal_name}: #{alt_id} #{b}  sex: #{sex}"

			journal = Journal.find_by_alt_id_and_title_and_group_id(alt_id, journal_name, team_id)

			next unless journal

			connect(journal, follow_up, couple, do_save)
			
			i = i + 1
		end
	end

	def find_dupe_entries(team_id = 9259, survey_id = 9, follow_up = 1)
		group = Group.find(team_id)
		query = "select je.id, count(je.id) as count from journal_entries je
			where je.group_id = #{team_id} and je.follow_up = #{follow_up} and je.survey_id = #{survey_id}
			group by je.journal_id
			having count > 1"

		puts "query: #{query}"

	    dupes = ActiveRecord::Base.connection.execute(query).each(:as => :hash).inject({}) do |col,j| 
		    col[j['id'].to_i] = j['count'].to_i
	    	col
    	end

    	results = []

		dupes.each do |journal_entry_id, count|
			puts "journal_entry_id: #{journal_entry_id}, count: #{count}"
			
			journal_entry = JournalEntry.find journal_entry_id
			if !journal_entry
				puts "not found: #{journal_entry_id}"
			end

			# double check that it's a duplicate
			journal = journal_entry.journal

			check_dupes = journal.journal_entries.where(:journal_id => journal.id, :group_id => team_id, :follow_up => follow_up, :survey_id => survey_id)
			if check_dupes.size > 1
				puts "dupes found (#{check_dupes.size}): #{check_dupes.map {|e| e.id}.inspect}"
				answered, not_answered = check_dupes.partition {|je| je.answered_at}
				puts "answered: #{answered.size}, not_answered: #{not_answered.size}"

				results += not_answered
			end
		end

		results
	end

	def delete_dupe_entries(team_id = 9259, survey_id = 9, follow_up = 1, do_save = false)
		dupes = find_dupe_entries(team_id, survey_id, follow_up)

		if dupes.any? && do_save
			puts "Found dupes in journals: #{dupes.map {|e| [e.journal_id, e.survey_id, e.follow_up, e.answered_at]}.inspect}"
			puts "Press 'y' to delete duplicates"
			ok = gets.chomp
			if ok == "y"
				puts "Deleting #{dupes.map {|je| je.id}.inspect}"
				dupes.map &:destroy
			end
		end
	end

	def fix_twin_email(team_id = 9259)
		jjs = Journal.where("group_id = ? and alt_id != '' and (parent_email = '' or parent_email is null)", team_id)
		puts "found #{jjs.count} journals without parent_email"
		jjs.each do |j|
			with_emails = Journal.for_group(team_id).where(:alt_id => j.alt_id) # get twin with same alt_id
			with_email = with_emails.select {|a| !a.parent_email.blank? }
			if with_email.any?
				other_twin = with_email.first
				puts "found parent_email by other twin: #{other_twin.parent_email}: #{other_twin.title} -> #{j.title} "
				j.parent_email = other_twin.parent_email
				j.save
			end
		end
	end

	def add_surveys_and_entries(journal, surveys = [], follow_up = 0, do_save = false)
		puts "when errors, did you want to save the created entries?  do_save: #{do_save}" if !do_save
		if surveys.any?
			entries_with_follow_up = journal.journal_entries.select {|e| e.follow_up == follow_up }
			if entries_with_follow_up.any? # add extra surveys
				je_surveys = journal.not_answered_entries.select {|je| je.follow_up == follow_up }.map &:survey
				add_surveys = surveys - je_surveys
				puts "surveys: #{add_surveys.map &:inspect}"
				journal.add_journal_entries(add_surveys, follow_up) if do_save
			elsif !journal.not_answered_entries.select {|e| e.follow_up == follow_up }.any?
				puts "Add journal entries: #{surveys.inspect} #{follow_up}"
				journal.add_journal_entries(surveys, follow_up) if do_save
			end
		end
		journal.not_answered_entries.with_followup(follow_up).where('survey_id IN (?)', surveys)
	end

	def connect_entries(entries, couple, do_save)
		raise "connect_entries: no entries given" if !entries.any?
		JournalEntryService.new.connect_entries(entries, couple, do_save)
		# couple.each do |k,v|
		# 	src = entries.select {|e| e.survey_id == k}.first
		# 	dst = entries.select {|e| e.survey_id == v}.first
		# 	src.next = dst.id
		# 	src.save if do_save
		# end
	end

	def connect(journal, follow_up, couple, do_save) 
		couple.each do |k,v|
			src = journal.journal_entries.select {|e| e.follow_up == follow_up && e.survey_id == k}.first
			dst = journal.journal_entries.select {|e| e.follow_up == follow_up && e.survey_id == v}.first
			src.next = dst.id
			src.save if do_save
		end
	end

	def get_date(d)
		# d = d.gsub("/", "-") if d.include? "/"
		i = d.index "-"
		if d.length == 5    # dmmyy and ddmmyy
			d = "0#{d}"
		end

		if d.length == 6    # ddmmyy
			y = d[4..5].to_i
			m = d[2..3].to_i
			d = d[0..1].to_i
			puts "ddmmyy #{d}-#{m}-#{y}"
			return Date.new(y,m,d)
		elsif d.length == 8 # dd-mm-yy
			puts "d.length == 8: #{d}"
			return Date.new(2000 + b[4..5].to_i, b[2..3].to_i, b[0..1].to_i)
		elsif i == 4 # yyyy-mm-dd
			y = d[0..3].to_i
			m = d[5..6].to_i
			d = d[8..9].to_i
			puts "y-m-d #{y}-#{m}-#{d}"
			return Date.new(y,m,d)
		elsif d.length == 10 && d[4] == "-" # yyyy-mm-dd
			y = d[0..3].to_i
			m = d[5..6].to_i
			d = d[8..9].to_i
			return Date.new(y,m,d)
		elsif d.length == 10 && d[2] == "-" && d[5] == "-" # dd-mm-yyyy
			y = d[6..9].to_i
			m = d[3..4].to_i
			d = d[0..1].to_i
			return Date.new(y,m,d)
		else 	  # dd-mm-yyyy 
			y = d[6..9].to_i
			m = d[3..4].to_i
			d = d[0..1].to_i
			puts "d-m-y #{y}-#{m}-#{d}"
			return Date.new(y,m,d)
		end
	end


	def check_next(file = "aug_2010.csv", team_id = 9259)
		i = 1
		found = []
		not_found = []
		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{i} #{row}"
			i = i.succ
			next if row.blank?

			alt_id = row["alt_id"] || row["Graviditetsid"]
			b = row["birthdate"]
			journal_name = row["journalnavn"] || row["Bnavn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"] || row["Gender"]
			sex = sex == "d" || sex == "M" || sex == "1" || sex == "Dreng" && 1 || 2

			puts "#{journal_name}: #{alt_id} #{b}  sex: #{sex}"
			# next

			journal = Journal.find_by_alt_id_and_group_id(alt_id, team_id) #Journal.find_by_title_and_group_id(journal_name, team_id)


			if journal
				journal_entry = JournalEntry.where('group_id = ? and next > 0 and journal_id = ?', team_id, journal.id).first

				if journal_entry
					found << "Found #{journal_name} #{journal_entry.survey.title} => #{journal_entry.next_survey}"
				else
					puts "NOT FOUND: #{journal_name} #{journal.id}  alt_id: #{alt_id}"
				end
			else
				puts "NOT FOUND: #{journal_name}  row: #{i}, #{row}"
				not_found << alt_id
			end
			puts "Found: #{found.size}, not found: #{not_found.size}: alt_ids: #{not_found.inspect}"
			puts found.join("\n")
		end
	end

	def check_dupes(file = "aug_2010.csv", team_id = 9259)
		i = 1
		found = []
		not_found = []
		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{i} #{row}"
			i = i.succ
			next if row.blank?

			alt_id = row["alt_id"] || row["Graviditetsid"]
			b = row["birthdate"]
			journal_name = row["journalnavn"] || row["Bnavn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"] || row["Gender"]
			sex = sex == "d" || sex == "M" || sex == "1" || sex == "Dreng" && 1 || 2

			# next

			journal = Journal.find_all_by_alt_id_and_group_id(alt_id, team_id) #Journal.find_by_title_and_group_id(journal_name, team_id)

			if journal.size > 1
				puts "DUPE #{alt_id} #{journal_name}"
				found << alt_id
			end
			puts "Dupes: #{found.size}: alt_ids: #{found.uniq.inspect}"
			puts found.join("\n")
		end
	end
end
