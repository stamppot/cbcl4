class SubscriptionsUnpaidQuery


  def select_latest_unpaid(center_id)
    ["select s.center_id, sa.survey_id, sa.surveytype, count(sa.survey_id) as active_used from subscriptions s
inner join survey_answers sa on sa.survey_id = s.survey_id
where sa.center_id = #{center_id}
and s.center_id = #{center_id}
and ((s.most_recent_payment is null) OR (sa.created_at >= s.most_recent_payment))
group by sa.survey_id"].join(" ")

  end


  def query(center_id)
    counts = self.do_query(select_latest_unpaid(center_id)).inject([]) do |col, row|
      col << row
    end
  end


  def do_query(query = nil, to_hash = false)
	 # puts "DO_QUERY: #{@query.inspect}"
	mysql_result = ActiveRecord::Base.connection.select_all(query || self.query)
  end


  def find_start_end_periods(center_id)
  	first_period = ""
  	"select * from periods p
inner join subscriptions sub on sub.id = p.subscription_id
where center_id = 52
group by paid_on"
  end

end