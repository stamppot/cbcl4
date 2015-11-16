class CreateApiKey < ActiveRecord::Migration
  def self.up
      create_table :api_keys do |t|
        t.integer :center_id
        t.string :name
        t.string :api_key
        t.string :salt, :default => Random.new.hash.to_s
      
        t.timestamps
    end
  end

  def self.down
    drop_table :api_keys
  end

  def self.import
    c = Center.new :title => "TrialPartner"
    c.save

    key = ApiKey.new :center_id => c.id, :name => c.title
    key.save
    key = ApiKey.find(key.id)
    key.api_key = ApiKey.calculate(c.title + key.salt)
    key.save
  end
end