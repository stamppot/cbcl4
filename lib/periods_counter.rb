class PeriodsCounter

	# counts *counted* usage, not real usage (can differ)
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

	# counts *counted* usage, not real usage (can differ)
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


	# counts *counted* usage, not real usage (can differ)
    def print_used_per_period(center_id)
		query = []
		query << "select created_on as start, ifnull(paid_on, Now()) as end, survey_id, center_id, sum(used) as used "
		query << " from periods where center_id = #{center_id} "
		query << " group by start, end"
		periods_count = ActiveRecord::Base.connection.execute(query.join).each(:as => :hash).inject([]) do |col,j| 
			col << "#{j['start']} - #{j['end']} \tsurvey: #{j['survey_id']} \tc: #{j['center_id']} \tused: #{j['used']}"
   			col
      	end
      	puts periods_count.join("\n")
      	periods_count
    end

	# counts *counted* usage, not real usage (can differ)
    def count_per_period_all
    	count = Center.all.inject({}) do |col,center|
    		col[center.id] = count_sum_per_period(center.id)
    		col
    	end
    end


    def count_real_used_all(start, stop)
		stop_date = stop.blank? && "Now()" || "'#{stop.to_s(:db)}'"
    	query = []
		query << "select center_id, survey_id, count(id) as used  from survey_answers "
		query << "where  done = 1 "
		query << "and created_at between '#{start}' and #{stop_date}"
		# query << "and created_at between '2013-12-10' and '2015-09-03 20:48:55' "
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

	# total used in period
	def real_total_in_period(center_id, start, stop)
		stop_date = stop.blank? && "Now()" || "'#{stop.to_s(:db)}'"
		query = []
		query << "select center_id, survey_id, count(id) as used from survey_answers "
		query << "where  done = 1 and center_id = #{center_id.to_i} "
		query << "and created_at between '#{start.to_s(:db)}' and #{stop_date} "
		# query << "and created_at between '2013-12-10' and '2015-09-03 20:48:55' "
		query << "group by center_id, survey_id"

		count = ActiveRecord::Base.connection.execute(query.join).each(:as => :hash).inject(PeriodCount.new) do |p,j| 
			key = j['survey_id']
			p.start = start
			p.stop = stop
			p.center_id = center_id.to_i
			p.per_survey ||= {} #j['used']
      		p.per_survey[key] ||= []
      		p.per_survey[key] = j['used']
   			p
      	end
	end

    # counts survey_answer to determine how many were really used
    def count_real_used(center_id, start, stop)
    	# logger.info ("stop: #{stop}")
    	stop = stop.blank? && "Now()" || "'#{stop}'"
    	puts "count stop: #{stop}"
		query = []
		query << "select center_id, team_id, survey_id, count(id) as used from survey_answers "
		query << "where center_id = #{center_id} and done = 1 "
		query << "and created_at between '#{start}' and #{stop} "
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

    def count_real_used_in_period(period)
    	count_real_used(period.center_id, period.created_on, period.paid_on)
    end


    def details_usage(center_id, last_pay_date)
    	query = []
    	query << "SELECT COUNT(*) as used, survey_id, 1 as paid
    			  FROM survey_answers sa
    			  WHERE center_id = #{center_id.to_i} AND done = 1 
    		 	  AND (created_at >= '2000-01-01 00:00:00' AND created_at < '#{last_pay_date}')
				  GROUP BY survey_id 
				"
		query << " UNION
		  		  SELECT COUNT(*) as used, survey_id, 0 as paid
		  		  FROM survey_answers sa
		  		  WHERE center_id = #{center_id.to_i} AND done = 1 
		  		  AND (created_at >=  '#{last_pay_date}' AND created_at < Now())
		  		  GROUP BY survey_id"

		paid = 0
		unpaid = 0
		
		count = ActiveRecord::Base.connection.execute(query.join).each(:as => :hash).inject({}) do |col,j| 
			key = j['survey_id']
			if j['paid'] == 1
				puts "j: #{j.inspect}"
				paid += j['used']
				col[:paid] ||= {}
				col[:paid][key] = { 
	      			:used => j['used'],
    	  			:paid => j['paid'],
	      			:survey_id => j['survey_id']
				}	
			else
				unpaid += j['used']
				col[:unpaid] ||= {}
				col[:unpaid][key] = { 
	      			:used => j['used'],
    	  			:paid => j['paid'],
 	     			:survey_id => j['survey_id']
				}
			end
   			col
      	end

      	total = paid + unpaid
      	count[:total_paid] = paid
      	count[:total_unpaid] = unpaid
      	count[:total] = total
      	puts "details_usage count: #{count.inspect}"
      	count
    end
end


class PeriodCount
 	attr_accessor :center_id, :start, :stop, :total_used, :per_survey

 	def initialize
 		self.center_id = 0
 		self.total_used = 0
 		self.per_survey = {}
 	end
end