class LoginLetter < Letter

  validates_presence_of :surveytype
  validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up], :message => "Der findes allerede et brev for denne skematype og opfølgning for gruppen. Har du valgt den rigtige gruppe?"

  attr_accessible :surveytype, :follow_up

  def to_text_variables(journal_entry)
    # puts "LoginLetter.to_text_variables: #{journal_entry.inspect}"
    {
      :title => journal_entry.journal.title,
      :firstname => journal_entry.journal.firstname,
      :parent_email => journal_entry.journal.parent_email,
      :parent_name => journal_entry.journal.parent_name || "",
      :login => journal_entry.login_user.login,
      :password => journal_entry.password,
      :alt_id => journal_entry.journal.alt_id
    }
  end
  
  def self.find_by_priority(entry)
    st = entry.survey.surveytype
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up = ?', entry.journal.group_id, entry.follow_up])
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up is null', entry.journal.group_id]) unless letter
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up = ?', entry.journal.center_id, entry.follow_up]) unless letter
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up is null', entry.journal.center_id]) unless letter
    letter = LoginLetter.find_default(st) unless letter
    letter
  end

  def self.filter(params)
    params[:type] = "LoginLetter"
    Letter.filter(params)
  end

  
end