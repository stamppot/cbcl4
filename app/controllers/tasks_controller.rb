# encoding: utf-8

class TasksController < ApplicationController 
  
  def rerun
    @task = Task.find params[:id]
    # create new task, retire old
    @new_task = @task.clone
    @new_task.status = "To do"

    @new_task.save
    @task.status = 'Retried'
    @task.save

    redirect_to mail_task_log_path(param[:group_id])
  end
end