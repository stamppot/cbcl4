class ConvertRoles
	# def convert
	# 	query = "SELECT user_id, group_concat(role_id) as role_ids FROM roles_users group by user_id"
	# 	ActiveRecord::Base.connection.execute(query).each(:as => :hash).map do |row| 
	# 		puts "row: #{row.inspect}"
	#     	user = User.find(row["user_id"])
	#     	user.role_ids_str = row["role_ids"]
	#     	user.save
	# 	end
 #    end

 #    def convert_old # for rails 2.3
	# 	query = "SELECT user_id, group_concat(role_id) as role_ids FROM roles_users group by user_id"
	# 	User.find_each(:batch_size => 500) do |user|
	# 		user.role_ids_str = user.role_ids.join(',')
	# 		user.save
	# 	end
 #    end
end