ThinkingSphinx::Index.define :user, :with => :active_record, :delta => true do
  indexes name, :sortable => true
  indexes center.title, :as => :center_title
  indexes center.code, :as => :center_code

  has center_id, created_at
  set_property :delta => true
end


	# define_index do
	# 	# fields
	# 	indexes :name, :sortable => true
	# 	indexes center.title, :as => :center_title
	# 	indexes center.code, :as => :center_code
	# 	# attributes
	# 	has center_id, created_at #, login_user
	# end