class FollowUpLetter < Letter

  # validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up, :problematic], :message => "Der findes allerede et brev for dette skema, opfølgning, og problem type for gruppen. Har du valgt den rigtige gruppe?"
  validates_uniqueness_of :problematic, :scope => [:group_id, :follow_up], :message => "Der findes allerede et brev for denne problemtype... skema, opfølgning, og problem type for gruppen. Har du valgt den rigtige gruppe?"

  attr_accessible :surveytype, :follow_up, :problematic, :sender

  def insert_text_variables(journal)
    self.letter.gsub!('{{name}}', journal.title)
    self.letter.gsub!('{{navn}}', journal.title)
    self.letter.gsub!('{{firstname}}', journal.firstname)
    self.letter.gsub!('{{fornavn}}', journal.firstname)
    self.letter.gsub!('{{email}}', journal.parent_email)
    self.letter.gsub!('{{mor_navn}}', journal.parent_name || "")
    self.letter.gsub!('{{projektnr}}', journal.alt_id || "")
  end

  def to_text_variables(journal)
    {
      :title => journal.title,
      :firstname => journal.firstname,
      :parent_email => journal.parent_email,
      :parent_name => journal.parent_name || ""
    }
  end
  
  def self.find_by_priority(entry)
    st = entry.survey.surveytype
    letter = FollowUpLetter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up = ?', entry.journal.group_id, entry.follow_up])
    letter = FollowUpLetter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up is null', entry.journal.group_id]) unless letter
    letter = FollowUpLetter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up = ?', entry.journal.center_id, entry.follow_up]) unless letter
    letter = FollowUpLetter.find_by_surveytype(st, :conditions => ['group_id = ? and follow_up is null', entry.journal.center_id]) unless letter
    letter = FollowUpLetter.find_default(st) unless letter
    letter
  end

  def self.filter(params)
    params[:type] = "FollowUpLetter"
    Letter.filter(params)
  end
end