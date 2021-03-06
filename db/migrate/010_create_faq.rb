class Faq < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.integer :faq_section_id, :position
      t.string :question, :answer, :title
    end
    create_table :faq_sections do |t|
      t.string :title
      t.integer :position
    end
  end

  def self.down
    drop_table :faqs
    drop_table :faq_sections
  end
end
