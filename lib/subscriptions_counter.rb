class SubscriptionsCounter


	def count_sum_per_period(center_id)
		query = []
		query << "select created_on as start, ifnull(paid_on, Now()) as end, survey_id, center_id, sum(used) as total_used "
		query << " from periods where center_id = #{center_id} "
		query << " group by start, end"
		periods_count = ActiveRecord::Base.connection.execute(query.join).each(:as => :hash).inject({}) do |col,j| 
      		col[j['start']] = { 
      			:total_used => j['total_used'],
      			:start => j['start'].to_s(:db),
      			:stop => j['end'].to_s(:db),
      			:center_id => j['center_id'],
      			:survey_id => j['survey_id']
				}
   			col
      	end
    end

    def count_per_period_per_survey(center_id)
		query = []
		query << "select created_on as start, ifnull(paid_on, Now()) as end, survey_id, center_id, sum(used) as used "
		query << " from periods where center_id = #{center_id} "
		query << " group by start, end"
		periods_count = ActiveRecord::Base.connection.execute(query.join).each(:as => :hash).inject({}) do |col,j| 
			key = j['survey_id']
			key2 = j['start']
			col[key] ||= {}
      		col[key][key2] = { 
      			:used => j['used'],
      			:start => j['start'].to_s(:db),
      			:stop => j['end'].to_s(:db),
      			:center_id => j['center_id'],
      			:survey_id => j['survey_id']
				}
   			col
      	end
    end

    def count_per_period_all
    	count = Center.all.inject({}) do |col,center|
    		col[center.id] = count_sum_per_period(center.id)
    		col
    	end
    end

    # counts what really has been used
    def count_used(center_id)
    	periods = count_sum_per_period(center_id).values
    	periods.map do |hash|
    		start = hash[:start]
    		stop = hash[:stop]
    		survey_id = hash[:survey_id]
    	
    		# TODO: count survey_answers in period
    	end
    end

    def count_real_used_all(start, stop)
    	query = []
		query << "select center_id, survey_id, count(id) as used  from survey_answers "
		query << "where  done = 1 "
		# query << "and created_at between '#{start}' and '#{stop}'"
		query << "and created_at between '2013-12-10' and '2015-09-03 20:48:55' "
		query << "group by center_id, survey_id "

		survey_answer_count = ActiveRecord::Base.connection.execute(query.join).each(:as => :hash).inject({}) do |col,j| 
			key = j['center_id']
			key2 = j['survey_id']
			col[key] ||= {}
      		col[key][key2] = { 
      			:used => j['used'],
      			:start => start,
      			:stop => stop,
      			:center_id => j['center_id'],
      			:survey_id => j['survey_id']
				}
   			col
      	end

	end

    # counts survey_answer to determine how many were really used
    def count_real_used(center_id, start, stop)
		query = []
		query << "select center_id, team_id, survey_id, count(id) as used from survey_answers "
		query << "where center_id = #{center_id} and done = 1 "
		query << "and created_at between '#{start}' and '#{stop}'"
		# query << "and created_at between '2013-12-10' and '2015-09-03 20:48:55' "
		# query << "and survey_id = #{survey_id} "
		query << "group by survey_id"

		survey_answer_count = ActiveRecord::Base.connection.execute(query.join).each(:as => :hash).inject({}) do |col,j| 
			key = j['survey_id']
      		col[key] = { 
      			:used => j['used'],
      			:center_id => j['center_id'],
      			:survey_id => j['survey_id']
				}
   			col
      	end
    end
end