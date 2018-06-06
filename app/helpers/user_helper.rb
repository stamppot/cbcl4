# encoding: utf-8

module UserHelper

	def show_user_status(user)
		case user.state
		when 1 then "unconfirmed" 
		when 2 then ""
		when 3 then "locked"
		when 4 then "deleted"
		when 5 then "retrieved_password" 
		end
	end

end