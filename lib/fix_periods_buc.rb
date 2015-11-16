class FixPeriodBUC


	def dofixBUC
		center_id = 4803
		center = Center.find center_id
		stop = DateTime.new(2012,03,19)
		fix(stop, center, true)
	end

	def fix(stop, center, save = false)
		start = center.created_at
		periods = []
		center.subscriptions.each do |sub|
			p = Period.new(:active => false)
			p.survey_id = sub.survey_id
			p.created_on = start
			p.paid_on = stop
			p.paid = true
			p.center_id = center.id
			p.subscription_id = sub.id
			puts "p: #{p.valid?} #{p.inspect} "
			periods << p
		end

		if save
			periods.each &:save
		end
	end
end