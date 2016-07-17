class CenterSetting < ActiveRecord::Base

	belongs_to :center
	validates_presence_of :name, :value, :center

	scope :for_center, lambda { |center| where(:center_id => (center.is_a?(Center) ? center.id : center)) }
	scope :setting, lambda { |setting| where(:name => setting) }

	def self.get(center, setting, default = nil)
		setting = self.for_center(center).setting(setting).first
		if setting
			val = setting.value
			return default && default.is_a?(Integer) && val.to_i || val
		else
			default
		end
	end
end
