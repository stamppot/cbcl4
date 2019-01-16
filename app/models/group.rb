# encoding: utf-8
# The Group class represents a group record in the database and thus a group
# in the ActiveRbac model. Groups are arranged in trees and have a title.
# Groups have an arbitrary number of roles and users assigned to them. Child
# groups inherit all roles from their parents.
#
# The Group ActiveRecord class mixes in the "ActiveRbacMixins::GroupMixin" module.
# This module contains the actual implementation. It is kept there so
# you can easily provide your own model files without having to all lines
# from the engine's directory

# TODO: move needed functionality (primarily validation) from GroupMixin to here
# A group then has no roles anymore.
# 
class Group < ActiveRecord::Base
  # include ActiveRbacMixins::GroupMixins::Core

  attr_accessible :title, :code, :parent_id
  
  scope :direct_groups, lambda { |user| joins("INNER JOIN `groups_users` ON `groups`.id = `groups_users`.group_id").
    where("groups_users.user_id = ?", user.is_a?(User) ? user.id : user) }

  scope :for_user, lambda { |user| joins("INNER JOIN `groups_users` ON `groups`.id = `groups_users`.group_id").
    where("groups_users.user_id = ?", user.is_a?(User) ? user.id : user) }

  # scope :all_parents, lambda { |parent| where(parent.is_a?(Array) ? ["group_id IN (?)", parent] : ["group_id = ?", parent]) }
  scope :center_and_teams, -> { where('type != ?', "Journal") }
  scope :in_center, -> (center) { where('center_id = ?', center.is_a?(Center) ? center.id : center) }
  scope :and_parent, -> { includes(:parent) }
  scope :children, -> { where(:center_id => id) }
  scope :teams, -> { where(:center_id => id) }
  # scope :teams, -> { groups.where('groups.type == ?', 'Team')}
  # acts_as_tree :order => 'title'
          
  # belongs_to :parent
  has_many :letters
  has_and_belongs_to_many :users, :uniq => true
  

  def self.to_tree(groups)
    h = {}
    groups.each do |group|
      if group.center_id
        h[group.center] ||= []
        h[group.center] << group
        # puts "add t: #{group.title} c: #{group.center.title}"
      else
        # puts "add c: #{group.title}"
        h[group] ||= []
      end
    end
    h
  end

  def ancestors_and_self
    result = [self]
    if parent != nil
      result << parent.ancestors_and_self
    end

    return result.flatten
  end

  def descendants_and_self
    result = [self]
    for child in children
      result << child.descendants_and_self
    end
    return result.flatten
  end

  def children

  end

  def all_users
    result = []
    self.teams.each {|t| result << t.users }
    result.flatten!
    result.uniq!
    result
    # self.descendants_and_self.each { |group| result << group.users }
    #   result.flatten!
    #   result.uniq!
    # return result
  end


  def self.for_users(user_ids)
    query =
    "SELECT user_id, title FROM groups g
    inner join groups_users gu on gu.group_id = g.id
    where user_id IN (#{user_ids.join(',')})"
    # group by user_id"

    ActiveRecord::Base.connection.execute(query).each(:as => :hash).inject({}) do |col,r|
      # puts r.inspect
      user_id = r["user_id"]
      role = r["title"]
      col[user_id] = [] if col[user_id].nil?
      col[user_id] << role
      col
    end
  end

  def self.this_or_parent(id)
    Group.where(['id = ? OR parent_id = ?', id, id]).to_a.delete_if { |group| group.instance_of? Journal } # find(:all, :conditions => [ 'id = ? OR group_id = ?', id, id]).delete_if { |group| group.instance_of? Journal }
  end

  # returns Team or Center for id, or if not exists, all teams and centers of user
  def self.get_teams_or_centers(id, user)
    group = Group.and_parent.find_by_id(id)
    (group && !group.is_a?(Journal)) && [group] || user.center_and_teams
  end

  def get_title
    title # .force_encoding("UTF-8")
  end
  
  def parent_or_self
    self.is_a?(Center) && self || self.center
  end
  
  # all ascendants/parents
  # def ascendants
  #   groups = []
  #   parent = self.center
  #   while (!parent.nil?)
  #     groups << parent
  #     parent = parent.center
  #   end
  #   groups
  # end
  
  def group_code
    if self.is_a?(Team)
      self.team_code
    elsif self.is_a?(Center)
      "#{self.code}-000"
    else
      qualified_code
    end
  end
  
  def group_name_abbr
    words = title.split
    if words.size == 1 and words.first.size < 9
      return words.first
    end
    group_name = title.split.map {|w| w.first }.join.downcase.slice(0,4)
    if group_name.size < 2
      group_name = (group_name.scan /\p{Upper}/).join
    end
    group_name.gsub("--", "-")
  end
  
def login_prefix
    group_name = title.split.map {|w| w.first }.join.downcase.slice(0,4)
    num = LoginUser.count(:conditions => ['center_id = ? and login LIKE ?', center.nil? && id || center.id, group_name + "%"])
    num = num > 1 && rand(100000) || rand(1000)
    login_name = "#{group_name}-#{num}"

    while(LoginUser.find_by_login(login_name)) do
      num += rand(10000)
      login_name = "#{group_name}-#{num}"
    end
    login_name.gsub("Ø", "o").gsub("Æ", "ae").gsub("Å", "a").gsub("--", "-")
  end

  protected

    # We want to validate a group's title pretty thoroughly.
    # validates_uniqueness_of :title, 
    #                         :message => 'er navnet på en allerede eksisterende gruppe.'
    
    
    #  DANISH_CHARS = "\u00c0-\u00d6\u00d8-\u00f6\u00f8"
    # validates_format_of     :title, # \00c0-\00d6\00d8-\00f6\u00f8
    #                         :with => %r{^[\(w|Æ|Ø|Å|æ|ø|å|,|\w) \$\^\-\.#\*\+&'"]*$},
    #                         :message => 'må ikke indeholde ugyldige tegn.'
    validates_length_of     :title, 
                            :in => 2..100,
                            :too_long => 'skal have mindre end 100 bogstaver.', 
                            :too_short => 'skal have mere end to bogstaver.',
                            :allow_nil => false,
                            :if => Proc.new { |group| group.is_a?(Team) or group.is_a?(Center) }
    # validates_presence_of   :parent,
    #                         :message => ': overordnet gruppe skal vælges',
    #                         :if => Proc.new { |group| group.class.to_s != "Center" }
                            
end
