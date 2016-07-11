class MoveJournalEntries

 	def fix
		cor = Journal.find 11367
    gus = Journal.find 11368

    jes = JournalEntry.find [45231, 45232, 45623]
    
    move_journal_entries(jes, gus)
  end

  def move_journal_entries(journal_entries, dest_journal)
    gus = dest_journal

    journal_entries.each do |je|
      sa = je.survey_answer
      csa = sa.csv_survey_answer

      csa.journal_id = dest_journal.id if csa
      sa.journal_id = dest_journal.id if sa
      je.journal_id = dest_journal.id if je

      je.save if je
      sa.save if sa
      csa.save if csa

      if sa
        score_rapport = sa.generate_score_report(update = true)
        score_rapport.save_csv_score_rapport
      end
    end
  end
end