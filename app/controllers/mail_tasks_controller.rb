# encoding: utf-8

class MailTasksController < ApplicationController 
  
  def show
    @group = Group.find params[:id]
    set_params_and_find(params)
    @surveys = Survey.all.to_a.inject({}) { |h,elem| h[elem.id] = elem; h }.invert
    @count_failed = SendLetterFollowUpTask.count_failed

    respond_to do |format|
      format.html
      format.js { puts "JSSSSS"; render :partial => 'entries' }
      format.json { puts "JSON"; render :partial => 'entries' }
    end
  end

  
  def filter
    @group = Group.find params[:id]

    set_params_and_find(params)
    
    @answer_state = params[:state].join('-') ||  "2-4"
    @states = {'Completed' => 1, 'Failed' => -1, 'In Progress' => "0"} #JournalEntry.states
    respond_to do |format|
      format.html { render :partial => 'entries'}
    end
  end

  # def filter
  #   @group = Group.find params[:id]
  #   set_params_and_find(params)

  #   respond_to do |format|
  #     format.html
  #     format.js { puts "JS!!!"; render :partial => 'entries'}
  #   end
  # end
  
  # update reminder status for multiple journal_entries
  def update
    group = Group.find params[:id]
    puts "params: #{params.inspect}"

    status = params[:state]
    tasks = SendLetterFollowUpTask.find(params[:tasks])
    tasks.each do |task| 
      task.approved!
      task.save
    end
    flash[:notice] = 'Godkendte opfølgningsbreve'
    redirect_to mail_tasks_status_path(group, 3)
  end


  protected 
  
  # def export_csv(csv, filename, type = "application/vnd.ms-excel; charset=utf-8")
  #   bom = "\377\376"
  #   content = csv # Iconv.conv('utf-16le', 'utf8', csv)
  #   send_data content, :filename => filename, :type => type, :disposition => 'attachment'
  # end

  def set_params_and_find(params)
    states = params[:status]
    params[:selected_status] = params[:status]
    @state = Task.states.fetch (params[:state] || 0).to_i
    @start_date = 1.year.ago
    @stop_date = DateTime.now.end_of_day

    tasks_relation = SendLetterFollowUpTask.with_journal.with_status(@state).between(@start_date, @stop_date)
    @task_count = tasks_relation.count
    @tasks = tasks_relation.all(:order => 'created_at asc', :include => [:journal])
    @stop_date = @tasks.any? && @tasks.last.created_at || DateTime.now
  end

  def check_access
    return !!current_user
  end
end