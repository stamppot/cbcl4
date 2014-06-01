class FilterArgs
  def filter_date(start, stop)
    args = self.set_time_args(start, stop)
    args[:start_date] = args[:start_date].to_s(:db)
    args[:stop_date] = args[:stop_date].to_s(:db)
    return args
  end

   
  def self.filter_age(args)
    args[:age_start] ||= 1
    args[:age_stop] ||= 28

    if args[:age] && (start_age = args[:age][:start].to_i) && (stop_age = args[:age][:stop].to_i)
      if start_age <= stop_age
        args[:age_start] = start_age
        args[:age_stop] = stop_age
      else
        args[:age_start] = stop_age
        args[:age_stop] = start_age
      end
    end
    puts "filter_age: #{args.inspect}"
    return args
  end 
   
  def self.set_time_args(start, stop, args = {})
    if start.is_a?(Time) and stop.is_a?(Time)
      args[:start_date] = start
      args[:stop_date] = stop.end_of_day
    elsif start.is_a?(Date) and stop.is_a?(Date)
      args[:start_date] = start.to_time
      args[:stop_date] = stop.to_time.end_of_day
    else
      {:start_date => start, :stop_date => stop}.each_pair do |key, date|
        unless date.blank?
          y = date[:year].to_i
          m = date[:month].to_i
          d = date[:day].to_i
          args[key] = Date.new(y, m, d).to_time
        end
      end
    end
    args
  end
end