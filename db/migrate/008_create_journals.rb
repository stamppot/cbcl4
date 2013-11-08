class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.string :title, :code
      t.integer :team_id, :center_id, :delta
      t.timestamps
    end
  end

  def self.down
    drop_table :journals
  end
end