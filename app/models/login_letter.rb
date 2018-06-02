class LoginLetter < Letter

  validates_presence_of :surveytype
  validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up, :bundle], :message => "Der findes allerede et brev for denne skematype og opfølgning for gruppen. Har du valgt den rigtige gruppe?"

  attr_accessible :surveytype, :follow_up, :bundle

  def to_text_variables(journal_entry)
    # puts "LoginLetter.to_text_variables: #{journal_entry.inspect}"
    {
      :title => journal_entry.journal.title,
      :firstname => journal_entry.journal.firstname,
      :parent_email => journal_entry.journal.parent_email,
      :parent_name => journal_entry.journal.parent_name || "",
      :login => journal_entry.login_user.login,
      :password => journal_entry.password,
      :alt_id => journal_entry.journal.alt_id || ""
    }
  end
  
  def self.find_by_priority(entry)
    st = get_letter_type(entry)
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up = ? and bundle = ?', entry.journal.group_id, entry.follow_up, entry.survey.bundle])
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up is null and bundle = ?', entry.journal.group_id, entry.survey.bundle]) unless letter
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up = ? and bundle = ?', entry.journal.center_id, entry.follow_up, entry.survey.bundle]) unless letter
    letter = LoginLetter.find_by_surveytype(st, :conditions => ['`type` = "LoginLetter" and group_id = ? and follow_up is null and bundle = ?', entry.journal.center_id, entry.survey.bundle]) unless letter
    letter = LoginLetter.find_default(st) unless letter
    letter
  end

  def self.filter(params)
    params[:type] = "LoginLetter"
    Letter.filter(params)
  end

  def self.get_letter_type(entry)
    # st = (entry.survey.category == "INFO" &&  ) && "info" ||
     entry.survey.surveytype
  end
  
end
