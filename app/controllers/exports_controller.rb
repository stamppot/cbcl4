class ExportsController < ApplicationController
  
  def index
    @center = current_user.center || current_user.centers.first #unless current_user.access? :admin
    @center ||= Center.find(params[:id]) if params[:id]
    
    puts "center: #{@center.inspect}"
    args = params
    # set default dates
    params[:start_date] ||= (JournalEntry.first_answered.first.answered_at.beginning_of_month)
    params[:stop_date] ||= (JournalEntry.last_answered.first.answered_at.end_of_month)

    params = filter_date(args)
    @start_date, @stop_date = params[:start_date], params[:stop_date]

    # filter age
    @start_age = params[:age_start] = 1
    @stop_age = params[:age_stop]  = 28
    params = FilterArgs.filter_age(args)

    @surveys = current_user.subscribed_surveys
    # set default value to true unless filter is pressed
    @surveys = surveys_default_selected(@surveys, params[:surveys])
    filter_surveys = @surveys.collect_if(:selected) { |s| s.id }
    
    # @center = current_user.center if current_user.centers.size == 1
    params[:center] = @center.id if @center
    
    # clean params
    params.delete(:action); params.delete(:controller); params.delete(:limit); params.delete(:offset)

    @centers = current_user.all_centers.sort_by {|c| c.title }.to_a
    @count_survey_answers = SurveyAnswer.filter_finished_count(current_user, params.merge({:surveys => filter_surveys}))
  end
  
  def filter
    params[:center] = params[:id].to_i if params[:id].to_i > 0
    center = Center.find params[:id] unless params[:id].blank? || params[:id] == '0'
    center ||= Center.find params[:center]
    center = current_user.center if current_user.all_centers.size == 1
    params.delete :team if params[:center] == params[:team]
    args = params.clone
    params = filter_date(args)
    params = FilterArgs.filter_age(params)
    # params[:team] = params[:team].delete :id if params[:team] && params[:team][:id]

    journals = if false && params[:team] && center.id != params[:team].to_i && !["null", "team", ""].include?(params[:team])
      team = Team.find(params[:team])
      journals = team.journals.count
    else
      params.delete :team
      center && center.journals.count || Journal.count
    end

    count_survey_answers = CsvSurveyAnswer.with_options(current_user, params).count

    render :json => {:text => "Journaler: #{journals}  Skemaer: #{count_survey_answers.to_s}"}
  end

  def download
    params[:center] = params[:id] if params[:id].to_i > 0
    center = Center.find params[:id] unless params[:id].blank? || params[:id] == '0'
    center = current_user.center if current_user.centers.size == 1
    params[:center] = center.id if current_user.centers.size == 1
    params.delete :team # if params[:center] == params[:team]
    args = params.clone
    params = filter_date(args)
    params = FilterArgs.filter_age(params)
    params.delete :team if ["null", "team", ""].include?(params[:team])
    # params[:team] = params[:team].delete :id if params[:team] && params[:team][:id]

    csv_survey_answers = CsvSurveyAnswer.with_options(current_user, params).all

    @task = Task.create(:status => "In progress", :group_id => center.id)
    @task.create_survey_answer_export(params[:survey][:id], csv_survey_answers)
  end

  # a periodic updater checks the progress of the export data generation 
  def generating_export
    @task = Task.find(params[:id])
    @completed = @task.completed?
    @file_path = @task.completed? && "/export_files/#{@task.export_file.id}" || ""
    @export_file = @task.export_file

    respond_to do |format|
      format.js {
        puts "GENERATING JS. Completed: #{@completed} #{@task.inspect}"
        # redirect_to export_file_path(@task.export_file) and return if @task.completed?
      }
      format.html do
        puts "GENERATING HTML"
        redirect_to export_file_path(@task.export_file) and return if @task.completed?
      end
    end
  end


  
  def show_range
    @start_date = Date.civil(params[:range][:"start_date(1i)"].to_i,params[:range][:"start_date(2i)"].to_i,params[:range][:"start_date(3i)"].to_i)
  end
  
  def set_age_range
    @start_age = params[:age][:start].to_i
    @stop_age  = params[:age][:stop].to_i

    render :update do |page|
      if @start_age > @stop_age
        params[:id] == "up" ? @stop_age = @start_age : @start_age = @stop_age

        page.replace_html 'select_age', :partial => 'select_age', :locals => {:start_age => @start_age, :stop_age => @stop_age}
        page.visual_effect :highlight, 'stop_age'
        page.visual_effect :highlight, 'start_age'
      end
      # page.hide 'filter_form'
    end
  end

  
  protected

  
  before_filter :header_javascript, :only => [:generating_export]
  
  def header_javascript
    response.headers['Content-type'] = 'text/javascript; charset=utf-8'
  end

  def filter_date(args)
    if args[:start_date] && args[:stop_date]
      start = args.delete(:start_date)
      stop  = args.delete(:stop_date)
    end
    FilterArgs.set_time_args(start, stop, args) # TODO: move to better place/helper?! also used in Query
  end
  
  def surveys_default_selected(surveys, params)
    if selected = params
      surveys.each { |s| s.selected = (selected["#{s.id}"] == "1") }
    else
      surveys.each { |s| s.selected = true }
    end
    return surveys
  end
  
  def check_access
    if !current_user || current_user.login_user
      redirect_to login_path
    end
  end
end
