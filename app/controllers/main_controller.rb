class MainController < ApplicationController
  layout 'cbcl'

  # caches_page :index
  # TODO: caches_action
  # caches_action :index, :cache_path => :index_cache_path.to_proc

  def index
    if request.query_string.present? 
      render :view => 'start/finish' and return
    end
    redirect_to login_path if current_user.nil?
  end

  def show
    raise "TEST EXCEPTION: #{session.inspect}"
  end
  
  protected

  def index_cache_path
    "#{params[:controller]}_#{params[:action]}_#{current_user.center_id}_#{current_user.highest_role.title}"
  end


  def check_access
    if current_user.nil?
      remove_current_user
      redirect_to login_path and return true
    end
    return true
  end
end
