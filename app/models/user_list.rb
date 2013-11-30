class UserList

	attr_accessor :roles, :groups, :users

	def initialize(center, options)
		self.users = User.users.in_center(center).paginate(options)
		user_ids = self.users.map &:id
		self.roles = Role.for_users(user_ids)
		self.groups = Group.for_users(user_ids)
	end
end