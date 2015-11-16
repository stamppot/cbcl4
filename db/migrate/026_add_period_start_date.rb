class AddPeriodStartDate < ActiveRecord::Migration
  def self.up
    add_column :periods, :start, :datetime, :null => false

    Period.find_each do |p|
    	p.start = p.created_on
    	p.save
    end
  end

  def self.down
    remove_column :periods, :start
  end
end