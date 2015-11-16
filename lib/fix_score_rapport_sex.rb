class FixScoreRapportSex

	def fix
	  sas = SurveyAnswer.where(:sex => 0)
          sas.each do |sa|
               entry = sa.journal_entry
               next if entry.nil?

      	       sa.sex = entry.journal.sex
		sa.save
		puts "#{entry.journal_id} sex not set"
	       if sa.score_rapport
               	sa.score_rapport.gender = sa.sex
		sa.score_rapport.save
		sa.score_rapport.regenerate(true)
		end
	    end
	end

end