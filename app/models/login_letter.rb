class LoginLetter < Letter

  validates_presence_of :surveytype
  validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up], :message => "Der findes allerede et brev for denne skematype og opfølgning for gruppen. Har du valgt den rigtige gruppe?"

  attr_accessible :surveytype, :follow_up

  def insert_text_variables(journal_entry)
    if journal_entry.login_user
      self.letter.gsub!('{{login}}', journal_entry.login_user.login)
      self.letter.gsub!('{{brugernavn}}', journal_entry.login_user.login)
    end
    self.letter.gsub!('{{password}}', journal_entry.password)
    self.letter.gsub!('{{kodeord}}', journal_entry.password)
    self.letter.gsub!('{{name}}', journal_entry.journal.title)
    self.letter.gsub!('{{navn}}', journal_entry.journal.title)
    self.letter.gsub!('{{firstname}}', journal_entry.journal.firstname)
    self.letter.gsub!('{{fornavn}}', journal_entry.journal.firstname)
    self.letter.gsub!('{{mor_navn}}', journal_entry.journal.parent_name || "")
    self.letter.gsub!('{{projektnr}}', journal_entry.journal.alt_id || "")
  end
  
  def to_mail_merge
    self.letter.gsub!('{{login}}', '{ MERGEFIELD login }')
    self.letter.gsub!('{{brugernavn}}', '{ MERGEFIELD brugernavn }')
    self.letter.gsub!('{{password}}', '{ MERGEFIELD password }')
    self.letter.gsub!('{{kodeord}}', '{ MERGEFIELD kodeord }')
    self.letter.gsub!('{{name}}', '{ MERGEFIELD name }')
    self.letter.gsub!('{{navn}}', '{ MERGEFIELD navn }')
    self.letter.gsub!('{{firstname}}', '{ MERGEFIELD firstname }')
    self.letter.gsub!('{{fornavn}}', '{ MERGEFIELD fornavn }')
    self.letter.gsub!('{{mor_navn}}', '{ MERGEFIELD mor_navn }')
    self.letter.gsub!('{{projektnr}}', '{ MERGEFIELD projektnr }')
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