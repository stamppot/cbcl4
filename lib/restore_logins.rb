require 'rubygems'
require 'csv'

class RestoreLogins

	def restore_entries(file = "journal_entries_backup.csv", change_data = false)
		i = 0
		entries = []
		not_created = []
		obsolete_lusers = []

		output_file = ""

		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			i += 1

			next if row.blank?

			puts "."

			je = JournalEntry.new
			#id;journal_id;survey_id;user_id;password;survey_answer_id;created_at;answered_at;state;updated_at;center_id;follow_up;
			#group_id;reminder_status;notes;answer_info;next

			je.id = row["id"].to_i
			je.user_id = row["user_id"].to_i
			je.journal_id = row["journal_id"].to_i
			je.survey_id = row["survey_id"].to_i
			je.created_at = DateTime.strptime(row["created_at"], "%Y-%m-%d %H:%M:%S")
			je.updated_at = DateTime.strptime(row["updated_at"], "%Y-%m-%d %H:%M:%S")			
			je.password = row["password"]
			je.state = row["state"].to_i
			je.center_id = row["center_id"].to_i
			je.follow_up = row["follow_up"].to_i
			je.group_id = row["group_id"].to_f
			je.reminder_status = row["reminder_status"]
			je.notes = row["notes"]
			je.next = row["next"].to_i

			exists = JournalEntry.find_by_id(je.id)
			if exists

				if je.user_id == exists.user_id
					not_changed = "user_id not changed, skipping  #{exists.user_id}  org.created_at #{je.created_at}  curr_created: #{exists.created_at}"
					puts not_changed
					output_file << not_changed << "\n"
					next
				end

				msg_exists = "Entry already exists: #{je.id}   org_user_id: #{je.user_id}   curr_user: #{exists.user_id}   org_created: #{je.created_at}   curr_created: #{exists.created_at} "
				puts msg_exists
				output_file << msg_exists << "backup: #{je.inspect}" << "exists: #{exists.inspect}" << "\n"
					
				obsolete_lusers << exists.user_id
				not_created << je

				if change_data # really run the update
					ch_msg = "change user_in on entry: #{exists.id}  #{exists.user_id} -> #{je.user_id}"
					puts ch_msg
					output_file << ch_msg << "\n"
					exists.notes = "alt_login #{exists.user_id}"
					exists.user_id = je.user_id
					exists.save
				end

				next
			end

			luser = LoginUser.find_by_id(je.user_id)
			if luser.nil?
				puts "LoginUser not found!!! #{je.inspect}"
				not_created << je
				next
			end

			# je.save
			entries << je
			puts "#{je.id}  user_id #{je.user_id} created"
		end

		File.open("restore_entries" + DateTime.now.strftime("%Y%m%d_%H%M%S") + ".log", 'w') { |file| file.write(output_file) }


		puts "Processed #{i} rows"
		puts "Restored #{entries.size} entries"
		puts "Obsolete login-users: #{obsolete_lusers.size}"
		puts "Not restored: #{not_created.size}:   "
	end

	def restore_lusers(only_user_id = nil, file = "backup_lusers_center52.csv")
		i = 0
		users = []
		not_created = []
		errors = []

		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			i += 1

			user_id = row["id"].to_i

			if only_user_id
				puts "not looking for #{user_id}  but for #{only_user_id}"
				next if user_id != only_user_id
				puts "found user_id: #{user_id}"
			end

			next if row.blank?

			puts "."

			# ue = User.find_by_id row["id"].to_i
			# ue.destroy if ue
			# next
			u = User.new
			u.id = row["id"].to_i
			u.created_at = DateTime.strptime(row["created_at"], "%Y-%m-%d %H:%M:%S") unless row["created_at"].nil?
			u.updated_at = DateTime.strptime(row["updated_at"], "%Y-%m-%d %H:%M:%S") unless row["updated_at"].nil?
			u.last_logged_in_at = DateTime.strptime(row["last_logged_in_at"], "%Y-%m-%d %H:%M:%S") unless row["last_logged_in_at"].nil?
			u.login_failure_count = row["login_failure_count"].to_i
			u.login = row["login"]
			u.name = row["name"]
			u.email = row["email"]
			u.password = row["password"]
			u.password_hash_type = "md5"
			u.password_salt = row["password_salt"]
			u.state = row["state"].to_f
			# user_id = row["user_id"].to_i
			u.center_id = row["center_id"].to_i
			u.login_user = row["login_user"].to_i
			u.delta = row["delta"]
			u.role_ids_str = row["role_ids_str"]

			# puts "#{u.inspect}"
			exists = User.find_by_id(u.id)

			if u.login == "s-9202" || u.id == 57989
				puts "exists: #{exists.inspect}"
				puts "u: #{u.inspect}"
				# return
			end


			if exists
				puts "User already exists: #{u.id}   org_login: #{u.login}   curr_login: #{exists.login}   org_created: #{u.created_at}   curr_created: #{exists.created_at} "
				not_created << u
				next
			end

			success = u.save
			users << u
			if success
				puts "#{u.id} #{u.login} created"
			else
				l_exists = User.find_by_login(u.login)
				errors << "could not create user: #{u.errors.inspect}   existing: #{l_exists.inspect}"
				puts errors.last
				
				u.login << "x"
				u.save
				# return
			end

		end

		puts "Errors: #{errors.size}   #{errors.inspect}"
		puts "Processed #{i} rows"
		puts "Restored #{users.size} users"
		puts "Not restored: #{not_created.size}:  #{not_created.inspect} "
	end
 	
	def read(file = "user_logins_passwords2.csv")

		i = 1
		mismatches = 0
		to_fix = []
		users_not_found = []
		output = ""

		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			i+= 1
			# puts "Row: #{i} #{row}"
			next if row.blank?
			journal_entry_id = row["journal_entry_id"].to_i
			# puts "je_id #{journal_entry_id}"
			next if journal_entry_id == 0
			puts "."

			journal_id = row["journal_id"].to_i
			user_id = row["user_id"].to_i
			center_id = row["center_id"].to_i
			group_id = row["group_id"].to_i
			login = row["login"]
			password = row["password"]
			created_at = row["created_at"]
			alt_id = row["alt_id"]

			journal_entry = JournalEntry.find_by_id(journal_entry_id)

			if journal_entry.nil?
				puts "journal_entry not found: #{journal_entry_id}"
				next
			end

			journal = journal_entry.journal

			puts "user_id: #{user_id}  ==  #{journal_entry.user_id}"
			if user_id != journal_entry.user_id
				mismatches += 1

				luser = User.find_by_id(user_id)
				if luser.nil?
					users_not_found << user_id
					puts "User not found: #{user_id}"
					next
				end
				puts "#{alt_id} je_id #{journal_entry_id} login, password: #{login}, #{password}  user was: #{luser.login} #{journal_entry.password}   #{journal.alt_id} "

				# luser.destroy
			end

			if luser.password != password
				mismatches += 1

				puts "pw je_id #{journal_entry_id} login, password: #{login}, #{password}  user was: #{luser.login} #{journal_entry.password}   #{journal.alt_id} "
			end

			output = CSV.generate(:col_sep => ";", :row_sep => :auto) do |csv_output|
      			csv_output << ["user_id"]  # header
      			users_not_found.each { |line| csv_output << [line] }
    		end

		end

		puts "\n\n"
		puts "Rows read: #{i}"
		puts "users not found: #{users_not_found.size}"
		puts "mismatches: #{mismatches}"

    		File.open("missing_users.csv", 'w') { |file| file.write(output) }

		output
	end

end
