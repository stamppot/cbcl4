# encoding: utf-8

class UsersController < ApplicationController # ActiveRbac::ComponentController
  layout 'cbcl', :except => [:center, :live_search]
  # layout 'empty', :only => [:users]
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  # We force users to use POST on the state changing actions.
  # verify :method       => :delete, :only => :destroy, :redirect_to => :show, :add_flash => { :error => 'Wrong request type: cannot delete'}

  before_filter :find_user, :except => [:index, :new, :create, :center, :live_search ]
  before_filter :check_access, :except => [:index, :list, :live_search, :page]

  # 31-12 Administrators cannot see other users
  def index
    @page_title = "CBCL - Liste af Brugere"
    @sort = params[:sort] || 'users.created_at'
    @order = params[:order] || "asc"

    @users = current_user.get_users(:page => params[:page], :per_page => Journal.per_page, :sort => params[:sort], :order => params[:order])

    if !params[:partial]
      render
    else
      render :partial => 'users/users', :layout => false
    end
  end

  # Show a user identified by the +:id+ path fragment in the URL. Before_filter find_user
  def show
    @page_title = "CBCL - Detaljer om bruger " + @user.login
    @groups = @user.center_and_teams

    group_ids = @groups.map {|g| g.id }.join(',')
    query = "select center_id, count(*) as count from journals where center_id IN (#{group_ids}) group by center_id"
    puts query
    @groups_count = ActiveRecord::Base.connection.execute(query).each(:as => :hash).inject({}) do |col,j| 
      col[j['center_id']] = j['count']; col
    end
  end

  # Displays a form to create a new user. Posts to the #create action.
  def new
    @roles = current_user.pass_on_roles || []  # logged-in user can give his own roles to new user
    @user = User.new
    
    if !params[:id].nil?   # create new user for specific center/team
      @groups = Group.this_or_parent(params[:id])
      @group = Group.find(params[:id])
      @user.groups += @groups
    else
      @group = current_user.center || current_user.centers.first
      @groups = current_user.center_and_teams
    end
  end


  def create
    group_id = params[:user][:groups].first
    role_ids = params[:user][:roles]
    group_ids = params[:user][:groups]
    
    @user = current_user.create_user(params[:user])

    if !(current_user.access_to_roles?(role_ids) && current_user.access_to_groups?(group_ids))
      flash[:error] = "No access to role or group"
      redirect_to users_path and return
    end

    roles = Role.where(id: role_ids).to_a
    g = Group.where(id: group_ids).to_a
    @user.groups = g
    @user.roles = roles
    @user.center = @user.groups.first.center

    if @user.save
      flash[:notice] = 'Brugeren blev oprettet.'
      redirect_to user_url(@user) and return
    else
      puts "user.groups: #{@user.groups.inspect}"
      puts "ERRORS: #{@user.errors.inspect}"
      @roles = current_user.pass_on_roles || []
      @group = Group.find(group_id)
      @groups = Group.this_or_parent(group_id)
      render :new
      # redirect_to new_user_url(group_id) #, :flash => { :error => @user.errors.to_a.join }
    end
  end
  
  def edit
    @roles = current_user.pass_on_roles
    @groups = current_user.center_and_teams
    puts "CENTER_AND_TEAMS: #{@groups.map &:title}"
    @user.password = ""
  end

  def update
    @user = User.find(params[:id])

    if current_user.update_user(@user, params[:user])
      save = @user.save
      puts "saved: #{save}, #{@user.inspect}"
      flash[:notice] = 'Brugeren er ændret.'
      redirect_to user_url(@user)
    else
      puts "update user failed: #{@user.inspect}"
      @user.password = ""
      @roles  = current_user.pass_on_roles || []  # logged-in user can give his own roles to new user
      @groups = current_user.center_and_teams
      redirect_to edit_user_path(@user)
    end
  end

  # Display a confirmation form (which asks "do you really want to delete this
  # user?") on GET. Handle the form submission on POST.
  def delete
  end
  
  def destroy
    @user = User.find params[:id]
    if not params[:yes].nil?
      @user.destroy
      flash[:notice] = 'Brugeren er slettet.'
      redirect_to users_path
    else
      flash[:success] = 'Brugeren blev ikke slettet.'
      redirect_to user_url(@user)
    end
  end
  
  def change_password
    if request.get?
      @user.password = ""
    else # post
      @user.change_password!(params[:user][:password])
      flash[:notice] = "Dit password er ændret."
      redirect_to surveys_path
    end
  end
  
  def live_search
    @raw_phrase = params[:name] # request.raw_post.gsub("&_=", "") || params[:id]
    puts "#{@raw_phrase}"
    @phrase = @raw_phrase.sub(/\=$/, "").sub(/%20/, " ")

    @users =
    if @phrase.empty?
      []
    elsif current_user.has_role?(:superadmin)
      User.search(@phrase, :order => "created_at DESC") # , :conditions => ['login_user = ?', false]
    else
      User.search(@phrase, :with => { :center_id => current_user.centers.map(&:id) })
    end
		@users.delete_if { |user| user.login_user }
		
    respond_to do |wants|
      wants.html  { render(:layout => false )}
      wants.js    { render(:layout => false, :template =>  "users/searchresults" )}
    end
  end
  
  def center
    @group = Center.find params[:id]
    @userlist = UserList.new(@group, {:page => params[:page], :per_page => 15})
    # @users = User.users.in_center(@group).paginate(:page => params[:page], :per_page => 15)
    # puts "params: #{params.inspect} #{params[:partial]}"

    # render :partial => 'center', locals: {group: @group}, :layout => false
    render :partial => 'user_list', locals: {group: @group, user_list: @userlist}, :layout => false
  end

  protected
  before_filter :login_access

  def User::per_page
    20 # REGISTRY[:default_users_paginate]
  end
   
  def find_user
    if params[:id]
      if current_user.access?(:superadmin) or current_user.access?(:admin)
        @user = User.find(params[:id])
      else
        @user = User.in_center(current_user.center).find(params[:id])
      end
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Du sendte en ugyldig forespørgsel.'
    redirect_to users_path
  end
    
    
  def login_access
    redirect_to login_path and return unless current_user
    if current_user.access? :all_users
      return true
    elsif !current_user.nil?
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to users_path
    else
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to login_path
    end
  end
  
  def check_access
    # puts "ACTION " + params[:action]
    # return true if params[:action] == "center"

    id = params[:id].to_i
    # puts "CHECK ACCESS #{current_user.inspect}"
    redirect_to login_path and return false unless current_user
    if current_user.access?(:user_show_all) || params[:action] == 'new'
      return true
    else
      access_list = User.users.in_center(current_user.center).map { |u| u.id } << 0
      unless access_list.include? id
        RAILS_DEFAULT_LOGGER.error("[ACCESS VIOLATION] current_user (#{current_user.id}) tried to access user #{id} #{params.inspect}}. Allowed list: #{access_list.inspect}")
        redirect_to login_path and return
      end
    end
    return true
  end
end