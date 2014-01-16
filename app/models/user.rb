# require 'access'
# require 'app/models/active_rbac_mixins/user_mixin.rb'

class User < ActiveRecord::Base
  # include ActiveRbacMixins::UserMixins::Core

	after_create  :index_search
  after_save    :expire_cache # delete cached roles, # groups
  after_destroy :expire_cache
  
  # has_many :roles, :through => :role_user
  # has_and_belongs_to_many :roles

  belongs_to :center
          
  has_and_belongs_to_many(:groups) do #, -> { where uniq: true }) do
    def teams
      self.select { |g| g.is_a?(Team) }
    end
    def centers
      self.select { |g| g.is_a?(Center) }
    end
  end
          
          # users have a n:m relation to roles
  has_and_belongs_to_many :roles #, -> { where uniq: true }

  validates_associated :center # center must be valid
  # validates_associated :roles
  # validates_presence_of :roles#, :message => "skal angives"
  # user must belong to a group unless he's superadmin or admin
  validates_associated :groups, :if => Proc.new { |user| !user.has_role?(:superadmin, :admin) }
  validates_presence_of :groups, :if => Proc.new { |user| !user.has_role?(:superadmin, :admin) }
  validates_presence_of :password
  
  attr_accessor :perms

	define_index do
		# fields
		indexes :name, :sortable => true
		indexes center.title, :as => :center_title
		indexes center.code, :as => :center_code
		# attributes
		has center_id, created_at #, login_user
	end

  # def roles
  #   @roles ||= Role.get_all_by_ids(role_ids_str.split(',').map &:to_i)
  # end

  def access?(permission)
    self.perms && self.perms.include?(permission)
  end  
  
  def has_access?(right)
    role_titles = Access.roles(right) # << "SuperAdmin"  # SuperAdmin has access to everything
    return false if role_titles.nil?

    roles.any? do |role| 
      role_titles.include?(role.title.to_sym)
    end
  end
  
  def login_user?
    login_user
  end

  scope :in_center, lambda { |center| where(:center_id => (center.is_a?(Center) ? center.id : center)) }
  scope :users, -> { where(:login_user => false).order("users.created_at") }
  scope :login_users, where(:login_user => true)

  scope :with_roles, lambda { |role_ids| joins(:roles).where('role_id IN (?)', role_ids) } 
  # scope :with_roles, lambda { |role_ids| where("FIND_IN_SET('#{role_ids.join(',')}', #{role_ids_str})") }
   # { :select => "users.*", :joins => "INNER JOIN roles_users ON roles_users.user_id = users.id",
    # :conditions => ["roles_users.role_id IN (?)", role_ids] } }
  scope :in_journals, lambda { |journal_ids| joins(:journal_entries).where('journal_entry_id IN(?)', journal_ids) } 
    # :conditions => ["journal_entries.journal_id IN (?)", journal_ids] } }

  # scope :with_roles, lambda { |role_ids| { :select => "users.*", :joins => "INNER JOIN roles_users ON roles_users.user_id = users.id",
  #   :conditions => ["roles_users.role_id IN (?)", role_ids] } }
  # scope :in_journals, lambda { |journal_ids| { :select => "users.*", :joins => "INNER JOIN journal_entries ON journal_entries.user_id = users.id",
  #   :conditions => ["journal_entries.journal_id IN (?)", journal_ids] } }

  # def condition_with_roles(role_ids)
  #   roles.map(&:id).any? {|r| role_ids.include?(r) };
  # end

	def self.run_rake(task_name)
		# load File.join(RAILS_ROOT, 'lib', 'tasks', 'thinking_sphinx_tasks.rake')
		# Rake::Task[task_name].invoke
	end

  def index_search
		# User.run_rake("rake thinking_sphinx:reindex")
	end
		
  def expire_cache
    Rails.cache.delete("user_roles_#{self.id}")
		Rails.cache.delete("journal_ids_user_#{self.id}")
		# Rails.cache.delete("journal_entry_ids_user_#{self.id}")
		# Rails.cache.delete_matched(/journal_ids_user_(.*)/)
  end
    
  def admin?
    self.has_role?(:admin) or self.has_role?(:superadmin)
  end
  
  #   {"user"=>{"roles"=>["5"], "name"=>"behandler test 22222", "groups"=>["121"], "login"=>"test 22222", "state"=>"2", "email"=>"behandler22222@test.dk"}, "submit"=>{"create"=>"Opret"}, "password_confirmation"=>"[FILTERED]", "action"=>"create", "controller"=>"active_rbac/user", "password"=>"[FILTERED]"}
  def create_user(params)
    # if user name not provided, it's same as login
    params[:name] = params[:login] if params[:name].blank?

    roles  = params.delete(:roles)
    groups = params.delete(:groups)
    # TODO: check parameters for SQL/HTML etc
    pw     = params.delete(:password)
    pwconf = params.delete(:password_confirmation)
    user = User.new(params)
    
    self.update_roles_and_groups(user, roles, groups)
    user.password_hash_type = "md5"
    user.password = pw
    user.password_confirmation = pwconf
    user.last_logged_in_at = 10.years.ago
    
    return user
  end


  def access_to_roles?(roles)
    roles = Role.find(roles || [])
    owner_roles = self.pass_on_roles
    roles.all? { |role| owner_roles.include?(role) }
  end

  def access_to_groups?(groups)
    groups = Group.find(groups || [])
    owner_groups = self.center_and_teams
    groups.all? { |group| owner_groups.include?(group) }
  end

  def highest_role
    self.roles.sort_by {|r| r.id}.first
  end

  def update_user(user, params) # user is the user who is being updated
    roles  = params.delete(:roles) || []
    groups = params.delete(:groups) || []
    
    if self.access_to_roles?(roles) && self.access_to_groups?(groups)
      self.update_roles_and_groups(user, roles, groups)
    else
      return false
    end

    # only update password when given
    unless params[:password].blank?
      user.password = params.delete(:password)
      user.password_confirmation = params.delete(:password_confirmation)
    end
    user.update_attributes(params)
  end

  # helper method used by methods above
  def update_roles_and_groups(user, roles, groups)
    if self.access_to_roles?(roles) && self.access_to_groups?(groups)
      roles = Role.find(roles || [])
      groups = Group.find(groups || [])

      user.roles = roles if roles.any?
      user.groups = groups if groups.any?

      user.center = groups.first.center unless groups.empty? or user.has_role?(:superadmin)
      user.save
      
      return user
    end
    return false
  end

  
  def access
    return Access.instance
  end
  
  def get_access(right)
    return Access.instance.roles(right.to_sym)
  end
          
  def status
  	rolename = case self.title
    when "parent" then   "forælder"
    when "youth" then   "barn"
	  when "teacher" then   "lærer"
	  when "pedagogue" then "pædagog"
	  when "other" then   "andet"
	  else self.title
	  end
  end
  
  def member_of?(group)
    group.users.include? self
  end
  
  # is User part of any groups in hierarchy
  def belongs_to?(group)
    group.all_users.include? self
  end

  # not strict, localadm also has access
  def team_member?(team)
    id = (team.instance_of? Team) ? team.id : team
    self.teams.map { |t| t.id }.include? id
  end
 
  def center_member?(center)
    id = (center.instance_of? Center) ? center.id : center
    if(self.has_access? :center_show_all)
      self.centers.map(&:id).include? id
    elsif self.center
      self.center.id == id
    else
      false
    end
  end
  
  def assigned_centers_and_teams
    if(self.has_access?(:admin))
      c = Center.find(1)
      groups = [c] + c.teams
    else
      self.center_and_teams
    end
  end

  def my_groups
    if self.id == 1
      center_and_teams
    elsif(self.has_access?(:admin))
      centers = self.groups.select {|g| g.is_a?(Center)}
      centers += centers.map {|c| c.teams}.flatten
    else
      center_and_teams
    end
  end

  def center_and_teams
    if(self.has_access?(:admin))
      # puts "CENTER_AND_TEAMS: admin"
      Group.center_and_teams
    else
      puts "CENTER_AND_TEAMS: #{self.roles.map &:title}"

      groups = self.centers
      groups.each do |center| 
        center.children.each { |team| groups << team if team.instance_of? Team }
      end
    end
  end
    
  def surveys
    surveys = []
    if self.has_access?(:survey_show_all)
      surveys = Survey.all(:order => :position).to_a
    elsif self.has_access?(:survey_show_subscribed)
      surveys = self.center.surveys.to_a
    elsif self.has_access?(:survey_show_login)
      journal_entry = JournalEntry.find_by_user_id(self.id)
      surveys = [journal_entry.survey]
    else
      surveys = []
    end
    surveys
  end

  # returns only active surveys which user's centers are subscribed to
  def subscribed_surveys
    if self.has_access?(:survey_show_all)
      s = Survey.all(:order => :position)
      # s.delete_if {|s| s.title =~ /Test/}
      # s
    elsif self.has_access?(:survey_show_subscribed)
      self.center.subscribed_surveys
    elsif self.has_access?(:survey_show_login)
      surveys = []
      journal_entry = JournalEntry.find_by_user_id(self.id)
      surveys << journal_entry.survey if journal_entry.survey
    else
      surveys = []
    end
  end
  
  def centers(options = {})
    options ||= {:include => :users}
    centers =
    if self.has_access?(:center_show_all)
      Center.find(:all, options) #.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }    # filtrer teams fra
    elsif self.has_access?(:center_show_admin)
      self.groups.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }
    elsif self.has_access?(:center_show_member)
      [self.center] # self.all_groups.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }
    elsif self.has_access?(:center_show_all)
      self.all_groups.delete_if { |group| group.instance_of? Journal or group.instance_of? Team }
    else
      []
    end
    centers
  end
  
  # must reload from DB
  def teams(reload = false)
    options = {:include => [:center, :users], :order => "title"}
    teams =
    if self.has_access?(:team_show_all)
      Team.includes([:center, :users]).order(:title) #all(options)
    elsif self.has_access?(:team_show_admin)
      Team.in_center(self.center_id).sort_by &:title
    elsif self.has_access?(:team_show_member)
      Team.direct_groups(self).sort_by &:title
    else
      []
    end
  end
  
  # journals a user has access to
  # behandler should only have access to journals in his teams (groups), thus excluding journals from other teams, but not the center
  def journals(options = {})
    options[:page] ||= 1
    options[:per_page] ||= Journal.per_page

    journals =
    if self.has_access?(:journal_show_all)
      if options[:page].to_i < 4 # only cache first pages, since they're used more often
        # TODO: cache
        # cache_fetch("journals_all_paged_#{options[:page]}_#{options[:per_page]}") do
          Journal.paginate(options)
        # end
      else
        Journal.paginate(options)
      end
    elsif self.has_access?(:journal_show_centeradm)
      # TODO: cache
      # cache_fetch("journals_groups_#{self.center_id}_paged_#{options[:page]}_#{options[:per_page]}", :expires_in => 10.minutes) do
        Journal.in_center(self.center).paginate(options)
      # end
    elsif self.has_access?(:journal_show_member)
      group_ids = self.group_ids(options[:reload]) # get teams and center ids for this user
      if options[:page].to_i < 4 # only cache first 5 pages
        # TODO: cache
        journals = # cache_fetch("journals_groups_#{group_ids.join("_")}_paged_#{options[:page]}_#{options[:per_page]}") do
          Journal.all_parents(group_ids).paginate(options)
        # end
      else 
        Journal.all_parents(group_ids).paginate(options)
      end
    elsif self.has_access?(:login_user)
      entry = JournalEntry.find_by_user_id(self.id)
      [entry.journal]
    elsif self.has_access?(:journal_show_none)
      journals = []
      journals = WillPaginate::Collection.create(options[:page], options[:per_page]) do |pager|
        pager.replace(journals) # inject the result array into the paginated collection:
      end
    else  # for login-user
      []  # or should it be the journal the login_user is connected to?
    end
    return journals
  end

  # ids of center, teams
  # def all_group_ids
  #   group_ids = [center_id] + teams.map(&:id)
  #   connection.execute("select id from journal_entries je where je.group_id in (#{group_ids.join(',')})")
  # end

  def change_password!(password)
    self.update_password(params[:user][:password])
    self.state = 2
    self.save
  end

  def has_journal_entry?(journal_entry_id)
    return true if admin?
    group_ids = []
    group_ids += (center_id && [center_id] || centers.map(&:id))
    group_ids += teams.map(&:id)
    result = connection.execute("select count(id) from journal_entries je where je.group_id in (#{group_ids.join(',')}) and je.id = #{journal_entry_id}")
    row = result.fetch_row
    row.any? && row.first.to_i > 0
  end

  def has_journal?(journal_id)
    group_ids = [center_id] + teams.map(&:id)
    journals_count = Journal.for_groups(group_ids).for(journal_id).count #(:select => "id")
  end

  # returns journal ids that this user can access. Used by check_access. SQL optimized
  def journal_ids
    group_ids = [center_id] + teams.map(&:id)
    j_ids = 
    if self.has_access?(:journal_show_all)
      journal_ids = Journal.all(:select => "id")
    elsif self.has_access?(:journal_show_centeradm)
      journal_ids = Journal.in_center(self.center).all(:select => "id")
    elsif self.has_access?(:journal_show_member)
      group_ids = self.group_ids(:reload => true) # get teams and centers for this users
      journal_ids = Journal.for_groups(group_ids).all_parents(group_ids).all(:select => "id")
    elsif self.has_access?(:journal_show_none)
      []
    else  # for login-user
      []  # or should it be the journal the login_user is connected to?
    end
    return j_ids.map {|j| j.id}
  end
  
  def login_users(options = {})
    options[:page] ||= 1
    options[:per_page] ||= 100000
    journal_ids = journal_ids # TODO: cache cache_fetch("journal_ids_user_#{self.id}", :expires_in => 10.minutes) { self.journal_ids }
    users = LoginUser.in_journals(journal_ids).paginate(options)
  end
  
  # returns users that a specific user role is allowed to see
  def get_users(options = {})
    options[:include] = [:roles, :groups, :center]
    options[:page]  ||= 1
    options[:per_page] ||= 20
    users = if self.has_access?(:user_show_all)  # gets all users which are not login-users
      User.users.with_roles(Role.get_ids(Access.roles(:all_real_users))).paginate(options).uniq
    elsif self.has_access?(:user_show_admins)
      User.users.with_roles(Role.get_ids(Access.roles(:user_show_admins))).paginate(options)
    elsif self.has_access?(:user_show)
      User.users.in_center(self.center).paginate(options)
    else
      WillPaginate::Collection.new(options[:page], options[:per_page])
    end
    return users
  end
    
  # roles a user can pass on
  def pass_on_roles
    r = self.roles
    if self.has_access?(:superadmin)
      r = Role.get(Access.roles(:all_users))
    elsif self.has_access?(:admin)
      r = Role.get(Access.roles(:admin_roles))
    elsif self.has_access?(:centeradm)
      r = Role.get(Access.roles(:center_users))
    end
    return (r.is_a?(Array) ? r : [r])
  end
  
  # def status
  #   I18n.translate("user.states.#{state}")
  # end

  # def User.stateToStatus(hash)
  #   ret = Hash.new
  #   hash.each do |key,val|
  #     case key
  #     when 'unconfirmed' then ret['ubekræftet'] = val
  #     when 'confirmed' then ret['bekræftet'] = val
  #     when 'locked' then ret['låst'] = val
  #     when 'deleted' then ret['slettet'] = val
  #     end
  #   end
  #   return ret
  # end
  def password_hash_type=(value)
    write_attribute(:password_hash_type, value)
    @new_hash_type = true
  end

  # After saving, we want to set the "@new_hash_type" value set to false
  # again.
  after_save '@new_hash_type = false'

  # Add accessors for "new_password" property. This boolean property is set 
  # to true when the password has been set and validation on this password is
  # required.
  attr_accessor :new_password

  # Generate accessors for the password confirmation property.
  attr_accessor :password_confirmation

  # Overriding the default accessor to update @new_password on setting this
  # property.
  def password=(value)
    write_attribute(:password, value)
    @new_password = true
  end
  
  # Returns true if the password has been set after the User has been loaded
  # from the database and false otherwise
  def new_password?
    @new_password == true
  end

  def update_password(pass)
    self.password_confirmation = pass
    self.password = pass
  end

  # After saving the object into the database, the password is not new any more.
  after_save '@new_password = false'

  def encrypt_password
    if errors.count == 0 and @new_password and not password.nil?
      # generate a new 10-char long hash only Base64 encoded so things are compatible
      self.password_salt = [Array.new(10){rand(256).chr}.join].pack("m")[0..9]; 

      # write encrypted password to object property
      write_attribute(:password, hash_string(password))

      # mark password as "not new" any more
      @new_password = false
      password_confirmation = nil
      
      # mark the hash type as "not new" any more
      @new_hash_type = false
    end
  end

  def all_roles
    return @_all_roles unless @_all_roles.blank?
    result = self.roles #.map { |role| role.ancestors_and_self }
    result.flatten!
    @_all_roles = result.uniq!

    return result
  end

  # This method returns all groups assigned to the given user - including
  # the ones he gets by being assigned through group inheritance.
  def all_groups
    result = Array.new

    for group in self.groups
      result << group.ancestors_and_self
    end

    result.flatten!
    result.uniq!

    return result
  end

  # This method returns true if the user is assigned the role with one of the
  # role titles given as parameters. False otherwise.
  def has_role?(*role_titles)
    titles = role_titles.map { |role| role.respond_to?(:title) && role.title.to_s || role.to_s }
    (roles.map(&:title) & titles).any?
  end


  def is_anonymous?
    false
  end

  def self.human_attribute_name (attr, options = {})
    return case attr
           when 'login' then 'User name'
           else attr.to_s.humanize
           end
  end

  # This static method removes all users with state "unconfirmed" and expired
  # registration tokens.
  # def self.purge_users_with_expired_registration
  #   registrations = UserRegistration.find :all,
  #                                         :conditions => [ 'expires_at < ?', Time.now.ago(2.days) ]
  #   registrations.each do |registration|
  #     registration.user.destroy
  #   end
  # end

  # This static method tries to find a user with the given login and password
  # in the database. Returns the user or nil if he could not be found
  def self.find_with_credentials(login, password)
    # Find user
    user = User.first :conditions => [ 'login = ?', login ]

    # If the user could be found and the passwords equal then return the user
    if not user.nil? and user.password_equals? password
      if user.login_failure_count > 0
        user.login_failure_count = 0
        self.execute_without_timestamps { user.save! }
      end

      # Sets the last login time and saves the object. 
      user.last_logged_in_at = Time.now
      user.save!
      
      return user
    end

    # Otherwise increase the login count - if the user could be found - and return nil
    if not user.nil?
      user.login_failure_count = user.login_failure_count + 1

      # self.class.execute_without_timestamps { user.save! }
      self.execute_without_timestamps { user.save! }
    end

    return nil
  end

  def password_equals?(value)
    return hash_string(value) == self.password
  end

  # Sets the last login time and saves the object. Note: Must currently be 
  # called explicitely!
  def did_log_in
    self.last_logged_in_at = DateTime.now
    self.class.execute_without_timestamps { save }
  end

  after_validation :encrypt_password

  protected
  
  def per_page
    Journal.per_page # REGISTRY[:journals_per_page]
  end
  
    # # This method allows to execute a block while deactivating timestamp
    # # updating.
    # def self.execute_without_timestamps
    #   old_state = ActiveRecord::Base.record_timestamps
    #   ActiveRecord::Base.record_timestamps = false
    # 
    #   yield
    # 
    #   ActiveRecord::Base.record_timestamps = old_state
    # end

    validates_presence_of   :login, :email, :password, :password_hash_type, :state,
                            :message => 'skal angives'

    validates_uniqueness_of :login, 
                            :message => 'findes allerede. Login skal være unikt.'
    validates_format_of     :login, 
                            :with => %r{[\(w|Æ|Ø|Å|æ|ø|å|\w) \-\.#\*\+&'"]*}, 
                            :multipline => false,
                            :message => 'må ikke indeholde ugyldige tegn.'
    validates_length_of     :login, 
                            :in => 4..100, :allow_nil => true,
                            :too_long => 'skal have mindre end 100 bogstaver.', 
                            :too_short => 'skal have mere end 4 bogstaver.'

    # We want a valid email address. Note that the checking done here is very
    # rough. Email adresses are hard to validate now domain names may include
    # language specific characters and user names can be about anything anyway.
    # However, this is not *so* bad since users have to answer on their email
    # to confirm their registration.
    validates_format_of :email, 
                        :with => %r{([\w\-\.\#\$%&!?*\'=(){}|~_]+)@([0-9a-zA-Z\-\.\#\$%&!?*\'=(){}|~]+)+},
                        :multipline => false,
                        :message => 'skal være en gyldig e-mail adresse.'

    def self.execute_without_timestamps
      old_state = ActiveRecord::Base.record_timestamps
      ActiveRecord::Base.record_timestamps = false
      yield
      ActiveRecord::Base.record_timestamps = old_state
    end

    # Overriding this method to do some more validation: Password equals 
    # password_confirmation, state an password hash type being in the range
    # of allowed values.
    def validate
      # validate state and password has type to be in the valid range of values
      errors.add(:password_hash_type, "must be in the list of hash types.") unless User.password_hash_types.include? password_hash_type
      # check that the state transition is valid
      errors.add(:state, "must be in the list of states.") unless state_transition_allowed?(@old_state, state)

      # validate the password
      if @new_password and not password.nil?
        errors.add(:password, 'må ikke være samme som brugernavn.') if password == :login
        errors.add(:password, 'må ikke være \'password\'.') if password == "password"
        errors.add(:password, 'skal have mellem 6 og 64 bogstaver eller tal.') unless password.length >= 6 and password.length <= 64
        errors.add(:password, 'skal passe med bekræftelse.') unless password_confirmation == password
        errors.add(:password, 'må ikke indeholde ugyldige bogstaver.') unless password =~ %r{^[\w\.\- !?(){}|~*_]+$}
      end

      # check that the password hash type has not been set if no new password
      # has been provided
      # if @new_hash_type and not (@new_password or password.nil?)
      #   errors.add(:password_hash_type, 'kan ikke ændres hvis password ikke er givet.')
      # end
    end
    
  private
    # This method returns a hash which contains a mapping of user states 
    # valid by default and their description.
    def self.default_states
      {
        'unconfirmed' => 1,
        'confirmed' => 2,
        'locked' => 3,
        'deleted' => 4,
        # The user has just retrieved his password and he must now
        # it. The user cannot anything in this state but change his
        # password after having logged in and retrieve another one.
        'retrieved_password' => 5
      }
    end

    # This method returns an array which contains all valid hash types.
    def self.default_password_hash_types
      [ 'md5' ]
    end

    # Hashes the given parameter by the selected hashing method. It uses the
    # "password_salt" property's value to make the hashing more secure.
    def hash_string(value)
      return case password_hash_type
             when 'md5' then Digest::MD5.hexdigest(value + self.password_salt)
             end
    end 
end