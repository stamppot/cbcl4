class FollowUpLetter < Letter

  # validates_uniqueness_of :surveytype, :scope => [:group_id, :follow_up, :problematic], :message => "Der findes allerede et brev for dette skema, opfølgning, og problem type for gruppen. Har du valgt den rigtige gruppe?"
  validates_uniqueness_of :problematic, :scope => [:group_id, :follow_up], :message => "Der findes allerede et brev for denne problemtype... skema, opfølgning, og problem type for gruppen. Har du valgt den rigtige gruppe?"

  attr_accessible :surveytype, :follow_up, :problematic

  def insert_text_variables(journal)
    self.letter.gsub!('{{name}}', journal.title)
    self.letter.gsub!('{{navn}}', journal.title)
    self.letter.gsub!('{{firstname}}', journal.firstname)
    self.letter.gsub!('{{fornavn}}', journal.firstname)
    self.letter.gsub!('{{email}}', journal.parent_email)
    self.letter.gsub!('{{mor_navn}}', journal.parent_name || "")
    self.letter.gsub!('{{projektnr}}', journal.alt_id || "")
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

  def self.filter(params)
    params[:type] = "FollowUpLetter"
    Letter.filter(params)
  end
end