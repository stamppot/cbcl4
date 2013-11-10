# require 'active_model'

class Role < ActiveRecord::Base
  # include ActiveModel::Validations
  # include ActiveRbacMixins::RoleMixins::Core
  
  # has_and_belongs_to_many :users #, -> { where uniq: true }
  # has_many :survey_answers
  
  # attr_accessor :id, :title

  # def initialize(id, name)
  #   self.id = id
  #   self.title = name
  # end

  def self.get(*roles)
    roles = roles.shift if roles.first.is_a?(Array)
    result = self.get_all(roles)
    return result.first if result.is_a?(Array) && result.size == 1
    result
  end

  # def self.find_by_title(title)
  #   result = Role.roles.invert.select {|r| r.title == title.to_sym }.flatten
  #   result.any? && result.first || nil
  # end

  def self.get_ids(*roles)
    puts "get_ids: #{roles.inspect}"
    result = self.get_all(roles)
    if result.is_a? Role
      result.id
    else
      result.map {|r| r.id}
    end
  end

  def self.get_all_by_ids(ids)
    ids.map {|id| Role.roles[id]}
  end

  def self.get_all(roles)
    result = []
    roles = roles.shift if roles.first.is_a?(Array)
    roles.each_with_index do |r,i|
      # TODO: cache
      # if "production" == Rails.env
        # result << cache_fetch("role_#{r}") { Role.find_by_title(r.to_s) }
      # else
        result << Role.find_by_title(r.to_s)
      # end
    end
    return result.compact
  end

  # def parent_id
  #   case id
  #   when 3 then 4       # centeradmin
  #   when 4 then 5       # teamadmin
  #   when 5 then nil     # behandler
  #   when 10 then        # login_bruger
  #   when 11..14 then 10         # parent, teacher, pedagogue, youth
  #   else nil
  #   end
  # end    

  def get_ids
    case id
    when 1 then [1,2,3,4,5]   # superadmin
    when 2 then [2]           # data
    when 3 then [3,4,5]       # centeradmin
    when 4 then [4,5]         # teamadmin
    when 5 then [5]           # behandler
    when 10 then [10,11,12,13,14,15] # login_bruger
    when 11 then [11]         # parent
    when 12 then [12]         # teacher
    when 13 then [13]         # pedagogue
    when 14 then [14]         # youth
    else []
    end
  end    


  # def self.get_all(ids) {
  #   ids.map { |id| Role.Roles[id] }
  # end

  # def find_by_id(id)
  #   Role.roles[id]
  # end

  # def find_by_id(id) {
  #   # if id.instance_of(Array)
  #   #   id.map {|i| Role.roles[id] }
  #   if id.is_a? String
  #     Role.roles[id.to_i]
  #   else
  #     Role.roles[id]
  #   end
  # end

  def Role.roles
    { 1 => Role.new(1, :superadmin),
      2 => Role.new(2, :data),
      3 => Role.new(3, :centeradmin),
      4 => Role.new(4, :teamadmin),
      5 => Role.new(5, :behandler),
      10 => Role.new(10, :login_bruger),
      11 => Role.new(11, :parent),
      12 => Role.new(12, :teacher),
      13 => Role.new(13, :pedagogue),
      14 => Role.new(14, :youth)
    }
  end
  
 #  def Role.login_users
 #    r = Role.get(:login_bruger)
 #    return r.children
 # end
 
  # validates_format_of     :title, 
  #                         :with => %r{[\w \$\^\-\.#\*\+&'"]*}, 
  #                         :multiline => false,
  #                         :message => 'must not contain invalid characters.'
  # validates_length_of     :title, 
  #                         :in => 2..100, :allow_nil => true,
  #                         :too_long => 'must have less than 100 characters.', 
  #                         :too_short => 'must have more than two characters.',
  #                         :allow_nil => false
 # def Role.rolle
 #   {
 #     "forælder" => 1,
 # 	   "pædagog"  => 2,
 #     "lærer"    => 3,
 #     "barn"     => 4,
 # 	   "andet"    => 88
 #   }
 # end
 
 # def Role.roller
 #   {
 #     "forælder" => "parent",
 #     "lærer"    => "teacher",
 # 	   "pædagog"  => "pedagogue",
 #     "barn"     => "youth",
 # 	   "andet"    => "other"
 #   }
 # end

  def parent
    Role.roles[self.parent_id]
  end

  def ancestors_and_self
    result = [self]
    result << parent.ancestors_and_self if parent != nil
    result.uniq!
    return result
  end

  # This method returns itself, all children and all children of its children
  # in a flat list.
  def descendants_and_self
    result = [self]
    children.each { |child| result << child.descendants_and_self }
    result.flatten!
    return result
  end

  # This method returns all users assigned to this role, its children
  # or any users assigned this role has been assigned through their roles.
  def all_users
    result = []

    self.descendants_and_self.each do |role|
      if role == self
        result << role.users 
      else
        result << role.all_users
      end
    end
    self.all_groups.each { |group| result << group.all_users }
    result.flatten!
    result.uniq!
    return result
  end

  # This method returns all groups this role has been assigned to and
  # all of their children.
  def all_groups
    result = []
    self.groups.each { |group| result << group.descendants_and_self }
    result.flatten!
    result.uniq!
    return result
  end

  # This method returns all permissions granted to this role and all
  # of its parents.
  # def all_static_permissions
  #   result = []
  #   ancestors_and_self.each { |role| result << role.static_permissions }
  #   result.flatten!
  #   result.uniq!
  #   return result
  # end

  # We're overriding "parent=" below. So we alias the one from the acts_as_tree
  # mixin to "old_parent=".
  # alias_method :old_parent=, :parent=

  # We protect the parent attribute here. If a group is given as a parent, that
  # is a descendant from this group, we raise a RecursionInTree error and stop
  # assignment.
  # def parent=(value)
  #   if descendants_and_self.include?(value)
  #     raise RecursionInTree, "Trying to set parent to descendant", caller
  #   else
  #     self.old_parent = value
  #   end
  # end

  # # This method blocks destroying a role if it still has children. This method
  # # raises a CantDeleteWithChildren exception if this error occurs. It is an 
  # # ActiveRecord event hook. 
  # def before_destroy
  #   raise CantDeleteWithChildren unless children.empty?
  # end

  # # Overriding this method to make "title" visible as "Name". This is called in
  # # forms to create error messages.
  # def human_attribute_name (attr)
  #   return case attr
  #          when 'title' then 'Name'
  #          else super.human_attribute_name attr
  #          end
  # end

  # protected

  # We want to validate a role's title pretty thoroughly.
  # validates_uniqueness_of :title, 
  #                         :message => 'is the name of an already existing role.'

  # Implement ActiveRecords' validate method here to enforce that parents in
  # tree are actually roles.
  # def validate
  #   errors.add(:parent, "must be a valid role.") unless parent.instance_of? Role or parent.nil?
  # end
end