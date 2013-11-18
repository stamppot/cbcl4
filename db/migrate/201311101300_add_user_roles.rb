class AddUserRoles < ActiveRecord::Migration
  def self.up
    add_column :users, :role_ids_str, :string, :size => 15
  end

  def self.down
    remove_column :users, :role_ids_str
  end
end