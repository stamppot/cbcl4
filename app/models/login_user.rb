# 24-2  A LoginUser is not a special user, but a role a user has! But also a type
# Do not obsolete, but use as abstraction/facade of user has role("login_bruger")
class LoginUser < User
  
  default_scope -> { order('id DESC') }

  has_one :journal_entry, :class_name => "JournalEntry", :foreign_key => "user_id"

  attr_accessible :login, :name, :email, :state, :login_user


  def journal
    self.all_groups.select { |group| group.instance_of? Journal }.first
  end

  def journals
    []
  end

  def get_journal
    query = "select group_id from groups_users where user_id = #{id}"
    j = ActiveRecord::Base.connection.execute(query).each(:as => :hash).map do |row| 
      group_id = row['group_id']
      journal = Journal.find_by_id(group_id)
    end
  end

  def survey
    self.journal_entry.survey
  end

  def surveys #  match User method  
    [self.journal_entry.survey]
  end
  
  def survey_answer
    self.journal_entry.survey_answer
  end

  def per_page
    20
  end
  
  def self.create_params(login, center_name) #, login_number, email = nil)
    # login = "#{center_name}-#{login_number}"
    # login_user = center.login_users.last(:conditions => ['login LIKE ?', "#{center_name}%"])
    # login = login_user && login_user.login.succ || login + "-1"
    # puts "LoginUser.create_params: #{login}"
    email ||= "#{login}@#{center_name}.dk"
    # login += "-1" if LoginUser.find_by_login(login)
    # while(LoginUser.find_by_login(login))
    #   login = login.succ
    # end
    return { :login => login,
      :name => login,
      :email => email,
      :state => 2,
      :login_user => true
    }
  end

def login_user_params
  params.permit(:login, :name, :email, :state, :login_user)
end

end