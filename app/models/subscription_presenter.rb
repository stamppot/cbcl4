class SubscriptionPresenter

  # Details view: subscription (one per survey), list of total, total_active (since last payment)
  # Summary view: periods
  # periods -> total used in period 
  attr_accessor :group, :subscriptions, :summary_view, :surveys, :periods, :detailed_view, :total_periods, :params

  def initialize(group, subscriptions = nil, params = {}) # for a group
    subscriptions ||= group.subscriptions(:include => :periods).to_a
    # surveys ||= subscriptions.map &:survey
    surveys ||= group.surveys
    @group = group
    @params = params
    @detailed_view = [] #{}
    @summary_view = {:periods => [], :total_periods => 0}
    @subscriptions = subscriptions.sort_by { |s| s.survey_id }
    # puts "surveys: #{surveys.inspect}" 
    @surveys = surveys.to_a.to_hash_with_key { |s| s.id }
    self.periods_summary(group, subscriptions)
    puts "surveys: #{surveys.map(&:id)}"
    puts "periods_summaries: #{@summary_view.inspect}"
    puts "periods_: #{@periods.inspect}"
    self.details
    self
  end
  
  # survey.title -> counts total, active per subscription (now in dbtable subscriptions)
  # counts total for all subscriptions
  def detail(subscription)
    active_period = subscription.find_active_period
    # active_count = subscription.find_active_period.used
    survey = @surveys[subscription.survey_id]

    date = active_period.created_on 
    stop = active_period.paid_on || DateTime.now
    # puts "Current_period: #{active_period.inspect}  date: #{date.inspect} stop: #{stop}"

    beginning = DateTime.new(2000,1,1).to_s(:db)
    counter = PeriodsCounter.new
    count_active = counter.count_real_used(subscription.center_id, date.to_s(:db), stop.to_s(:db), [survey.id])
    # puts "stop: #{stop}  #{count_active.inspect}"
    count_active[subscription.survey_id] ||= {:used => 0}
    
    # puts "count_used between: #{beginning} #{date.to_s(:db)}"
    count_used = counter.count_real_used(subscription.center_id, beginning, date.to_s(:db), [survey.id])
    # puts "count_used: #{count_used.inspect}"
    count_used[subscription.survey_id] ||= {:used => 0}

    count_all = counter.count_real_used(subscription.center_id, beginning, DateTime.now.to_s(:db), [survey.id])
    # puts "count_all: #{count_all.inspect}"
    count_all[subscription.survey_id] ||= {:used => 0}

    @detailed_view << {
      :subscription => subscription,
      :title => (survey && survey.get_title || "Ingen titel"),
      :total => count_all[subscription.survey_id][:used], # subscription.total_used,
      :unpaid => count_active[subscription.survey_id][:used], # subscription.unpaid_used,
      :paid => count_used[subscription.survey_id][:used], # subscription.paid_used,
      :note => subscription.note || "",
      # :paid => subscription.total_paid,
      :state => Subscription.states.invert[subscription.state],
      :start => subscription.created_at,
      # :count_total => subscription.total_used,
      # :count_paid => subscription.paid_used,
      # :count_unpaid => subscription.unpaid_used 
    }
  end

  def details # details for all subscriptions
    @subscriptions.each { |subscription| detail(subscription) }
    @detailed_view
  end

  # totals for all subscriptions
  def total_paid
    @group.subscriptions.sum { |s| s.total_paid }
  end

  def total_used
    @group.subscriptions.sum { |s| s.total_used }
  end

  def total_unpaid
    @group.subscriptions.sum { |s| s.active_used }
  end

  def periods_summary(group, subscriptions) # count totals in periods
    counter = PeriodsCounter.new
    summaries = @group.subscription_service.subscription_summary(subscriptions, @params).sort_by {|s| s.first }
    summaries.each do |summary|
      date, periods = *summary
      puts "periods_summary: #{date.inspect}  #{periods.inspect}"
        #used = periods.sum {|p| p["used"].to_i }
			# find period for date, get used amount
			 #current_period = get_period_for_date(periods, date)

      # puts "Current_period: #{current_period.inspect}  date: #{date.inspect}"
      active = periods.sum {|p| p["active_used"].to_i }
      is_paid = periods.all? { |p| p['paid'].to_i > 0 && p['paid_on']}
      paid_on = periods.detect { |p| p['paid_on'] }
      paid_on &&= paid_on['paid_on']
      stopped_on = periods.first["paid_on"]

      stop = ((paid_on || stopped_on) || DateTime.now)
      count = counter.count_real_used(group.id, date, stop)
      real_used = count.values.sum {|v| v[:used] }
      # id = periods["id"]
      puts "pperiods: #{periods.inspect}"
      puts "start/stop: #{date.inspect} #{stop.inspect}"
      puts "count real_used: #{real_used}"
      # puts "real used: #{real_used} #{date} #{stop}    used: #{used} #{date} #{stopped_on} #{paid_on}"
      @summary_view[:periods] << {
        # :id => id,
        :start_on => date, 
        :used => real_used, #used, #current_period["used"].to_i, #used,
        :real_used => real_used,
        :active => active,
        :paid => is_paid,
        :created => date,
        :stopped_on => stopped_on,
        :paid_on => paid_on
      }  
      @summary_view[:total_periods] += real_used   # used
    end
  end

	private
	def get_period_for_date(periods, date)
    # puts "Get_period_for_date: #{date.inspect}"
   	p = active_periods = periods.select { |p| p["created_on"] < date && p["paid_on"] > date}
		p = active_periods.first if active_periods.size == 1
		p = periods.last if !active_periods.any?
		p = periods.first
    # puts "Got_period_for_date: #{p.inspect}"
		p
	end    
end