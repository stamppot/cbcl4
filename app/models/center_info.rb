class CenterInfo < ActiveRecord::Base
  belongs_to :center
  
  validates_associated :center

  attr_accessible :street, :zipcode, :city, :telephone, :person, :ean  
end