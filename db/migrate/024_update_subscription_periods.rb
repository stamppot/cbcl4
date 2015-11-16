class UpdateSubscriptionPeriods < ActiveRecord::Migration
  def self.up
    add_column :periods, :center_id, :integer, :null => false
    add_column :periods, :survey_id, :integer, :null => false
  end

  def self.down
  end

  def self.import
    Period.all.each do |p|
      center_id = p.subscription.center_id
      survey_id = p.subscription.survey_id
      puts "center: #{center_id}  survey: #{survey_id}"
      p.center_id = center_id
      p.survey_id = survey_id
      puts "p: #{p.inspect}"

      p.save
    end
  end
end