# encoding: utf-8

class UsersController < ApplicationController # ActiveRbac::ComponentController
  layout 'cbcl', :except => [:center, :live_search]
  # layout 'empty', :only => [:users]
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  # We force users to use POST on the state changing actions.
  # verify :method       => :delete, :only => :destroy, :redirect_to => :show, :add_flash => { :error => 'Wrong request type: cannot delete'}

  before_filter :find_user, :except => [:index, :new, :edit, :update, :create, :center, :live_search ]
  before_filter :check_access, :except => [:index, :list, :live_search, :page, :create, :center]

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
    @page_title = "CBCL - Detaljer om bruger " + (@user && @user.login || "")
    @groups = @user.center_and_teams
    group_ids = @groups.map {|g| g.id }.join(',')

    query = "select center_id, count(*) as count from journals where center_id IN (#{group_ids}) group by center_id"
    # puts query
    @groups_count = ActiveRecord::Base.connection.execute(query).each(:as => :hash).inject({}) do |col,j| 
      col[j['center_id']] = j['count']; col
    end
  end

  # Displays a form to create a new user. Posts to the #create action.
  def new
    @roles = current_user.pass_on_roles.to_a || []  # logged-in user can give his own roles to new user
    @user = User.new
    
    params[:id] = current_user.center if params[:id] == "0"
    
    if !params[:id].nil?  # create new user for specific center/team
      @groups = Group.this_or_parent(params[:id])
      @group = Group.find(params[:id])
      @user.groups += @groups
    else
      @groups = if current_user.has_role?(:centeradmin)
      	Group.where(:center_id => current_user.center_id)
    	else	
 	      current_user.center_and_teams
	    end
    end

    if current_user.has_role?(:superadmin) # superadmin can create users in all groups
      @groups = (Center.all + current_user.center.teams).sort_by { |c| c.title  }
    end

  end

  def create
    if !params[:user][:groups]
      flash[:error] = "Du skal vælge et center eller team"
      redirect_to new_user_url(params[:id]) and return
    end

    role_ids = params[:user][:roles]
    group_ids = params[:user][:groups]
    
    @user = current_user.create_user(params[:user])

    if !(current_user.access_to_roles?(role_ids) && current_user.access_to_groups?(group_ids))
     logger.info("could not create user: roleIds: #{role_ids.inspect}, group_ids: #{group_ids.inspect}  access_to_roles: #{current_user.access_to_roles?(role_ids)}, access to groups: #{current_user.access_to_groups?(group_ids)}")
      flash[:error] = "No access to role or group"
      flash[:notice] = "Ingen adgang til den valgte rolle eller gruppe"
      redirect_to users_path and return
    end

    @user.assign_groups_and_roles(group_ids, role_ids)
    # roles = Role.where(id: role_ids).to_a
    # g = Group.where(id: group_ids).to_a
    # @user.groups = g
    # @user.roles = roles
    # @user.center = @user.groups.first.center

    if @user.save
      flash[:notice] = 'Brugeren blev oprettet.'
      redirect_to user_url(@user) and return
    else
      # puts "user.groups: #{@user.groups.inspect}"
      # puts "ERRORS: #{@user.errors.inspect}"
      @roles = current_user.pass_on_roles || []
      @groups = Group.this_or_parent(params[:id])
      render :new
    end
  end
  
  def edit
    @user = User.find params[:id]
    @roles = current_user.pass_on_roles
    @groups = if current_user.has_role?(:centeradmin)
	    Group.where(:center_id => current_user.center_id)
	  else
	    (@user.groups + current_user.center_and_teams).uniq
	  end
    @user.password = ""
  
    if current_user.has_role?(:superadmin) # superadmin can create users in all groups
      @groups = (current_user.center_and_teams + [@user.center] + @user.groups + @user.center.teams).sort_by { |c| c.title  }.uniq
    end
  end

  def update
    @user = User.find(params[:id])

    logger.info "users ctrl update"
    if current_user.update_user(@user, params[:user])
      save = @user.save
      # logger.info "saved: #{save}, #{@user.inspect}"
      flash[:notice] = 'Brugeren er ændret.'
      redirect_to user_url(@user)
    else
      logger.info "update user failed: #{@user.inspect}  \n#{params.inspect} \n #{@user.errors.inspect}"
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
      User.search(@phrase, :order => "created_at DESC") 
    else
      User.search(@phrase, :with => { :center_id => current_user.centers.map(&:id) })
    end
    @users.delete_if { |user| user && user.login_user? }
		
    respond_to do |wants|
      wants.html  { render(:layout => false )}
      wants.js    { render(:layout => false, :template =>  "users/searchresults" )}
    end
  end
  
  def center
    @group = Center.find params[:id]
    @userlist = UserList.new(@group, {:page => params[:page], :per_page => 100})
    #@userlist.roles = current_user.pass_on_roles.group_by {|r| || []
    render :partial => 'user_list', locals: {group: @group, user_list: @userlist}, :layout => false
  end

  def activate
    @user = User.find params[:id]

    # @user.state = 2
    @user.save

    respond_to do |wants|
      wants.html  { render(:layout => false, :success => true)}
      wants.js    { render(:layout => false, :success => true, :template =>  "users/searchresults" )}
    end
  end


  protected
  before_filter :login_access

  def User::per_page
    20 # REGISTRY[:default_users_paginate]
  end
   
  def find_user
    return unless current_user
    # return if params[:id] == 'new'
    if params[:id].to_i > 0
      if current_user.access?(:superadmin) or current_user.access?(:admin)
        @user = User.find(params[:id])
      else
        @user = User.in_center(current_user.center).find(params[:id])
      end
      raise ActiveRecord::RecordNotFound if @user.login_user?
      @user 
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
    if current_user.access?(:superadmin) || current_user.access?(:user_show_all) || params[:action] == 'new' || params[:id] == 'new'
      logger.info "check_access true"
      return true
    else
      access_list = User.users.in_center(current_user.center).map { |u| u.id } << 0
      unless access_list.include? id
        logger.error("[ACCESS VIOLATION] current_user (#{current_user.id}) tried to access user #{id} #{params.inspect}}. Allowed list: #{access_list.inspect}")
        redirect_to login_path and return
      end
    end
    return true
  end
end
