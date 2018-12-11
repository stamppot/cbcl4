ThinkingSphinx::Index.define :journal, :with => :active_record do
  indexes title, :sortable => true
  indexes code, :sortable => true
  indexes cpr, :sortable => true
  indexes alt_id, :sortable => true

  has group_id, center_id, created_at, updated_at
  set_property :delta => true
end

  # define_index do
  #    # fields
  #    indexes :title, :sortable => true
  #    indexes :code, :sortable => true
  #    indexes :cpr, :sortable => true
  #    indexes :alt_id, :sortable => true
		#  # indexes center_id
  #    # attributes
  #    # has group_id, center_id, created_at, updated_at
  #    has group_id, center_id, created_at, updated_at
  #    set_property :delta => true
  #  end