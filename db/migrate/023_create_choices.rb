class CreateChoices < ActiveRecord::Migration
  def self.up
    create_table :choices do |t|
      t.string :name, :full, :options
    end
  end

  def self.down
    drop_table :choices
  end

  def import(args)
    res = []
    args.each do |k,v|
      a = {:name => k, :options => v[:options].join(';;'), :full => v[:options]}
      puts a.inspect
      res << Choice.new(a)
    end
    res
  end
end