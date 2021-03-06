ThinkingSphinx::Index.define :user, :with => :active_record do
  indexes name, :sortable => true
  indexes center.title, :as => :center_title
  indexes center.code, :as => :center_code

  has group_id, center_id, created_at
end


	# define_index do
	# 	# fields
	# 	indexes :name, :sortable => true
	# 	indexes center.title, :as => :center_title
	# 	indexes center.code, :as => :center_code
	# 	# attributes
	# 	has center_id, created_at #, login_user
	# end