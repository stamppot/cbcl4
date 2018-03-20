require 'rubygems'
require 'csv'

class RestoreLogins

	def restore(file = "missing_users_backup.csv")
		i = 0
		users = []
		not_created = []

		CSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			i += 1

			next if row.blank?

			puts "."

			u = User.new
			u.id = row["id"].to_i
			u.created_at = DateTime.strptime(row["created_at"], "%Y-%m-%d %H:%M:%S")
			u.updated_at = DateTime.strptime(row["updated_at"], "%Y-%m-%d %H:%M:%S")
			u.last_logged_in_at = DateTime.strptime(row["last_logged_in_at"], "%Y-%m-%d %H:%M:%S")
			u.login_failure_count = row["login_failure_count"].to_f
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

			exists = User.find_by_id(u.id)
			if exists
				puts "User already exists: #{u.id}   org_login: #{u.login}   curr_login: #{exists.login}   org_created: #{u.created_at}   curr_created: #{exists.created_at} "
				not_created << u
				next
			end

			u.save
			users << u
			puts "#{u.id} #{u.login} created"
		end

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
