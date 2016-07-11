class FixGustav

 	def fix
		cor = Journal.find 11367
    gus = Journal.find 11368

    jes = JournalEntry.find [45231, 45232, 45623]
    
    jes.each do |je|
      sa = je.survey_answer
      csa = sa.csv_survey_answer

      csa.journal_id = gus.id
      sa.journal_id = gus.id

      je.save && sa.save && csa.save

      score_rapport = sa.generate_score_report(update = true) # generate score report
      score_rapport.save_csv_score_rapport
    end
  end
end