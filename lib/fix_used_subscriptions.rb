class FixUsedSubscriptions


	def fix_center(center_id, do_save = false)
		center = Center.find center_id
		periods = center.subscriptions.inject({}) {|col, s| col[s.survey_id] = s.find_active_period; col }
		suq = SubscriptionsUnpaidQuery.new.query(center_id).to_hash_with_key {|a| a["survey_id"]}

		# fix periods

		periods.each { |survey_id, p| puts "period used: #{p.used}  query: #{suq[survey_id] && suq[survey_id]['active_used'] || 'nop'}" }

		periods.each { |survey_id, p| p.used = suq[survey_id]["active_used"] if suq[survey_id] }
		# periods.each {|k, p| p.save }

		# fix subscriptions active_used
		center.subscriptions.each do |sub|
			active_period = sub.find_active_period
			old_active_used = active_period.used
			new_active_used = periods[sub.survey_id].used

			puts "Period #{sub.survey_id} was: #{old_active_used}  (#{center_id})"
			puts "Period #{sub.survey_id} now: #{new_active_used}  (#{center_id})"
			puts "Sub #{sub.survey_id} was: #{sub.active_used}  (#{center_id})"
			sub.active_used = new_active_used

			if do_save
				active_period.used = new_active_used
				sub.active_used = new_active_used
				active_period.save && sub.save
			end
		end
	end

	def fix_all_centers(do_save = false)
		Center.all.each {|c| puts "\nCENTER: #{c.id}: #{c.title}"; fix_center(c.id, do_save) }
	end
end