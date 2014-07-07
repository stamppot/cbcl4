class Choice < ActiveRecord::Base
	attr_accessible :name, :options, :full

	def get_options
		options.split(';;').inject({}) do |h, o|
			a = o.split('::')
			h[a.first] = a.second
			h
		end
	end
end