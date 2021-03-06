class ChartReport

  attr_accessor :journal, :titles, :groups, :scales, :group_titles

  def build(entry_ids, journal_id)
    # puts "ScoreReportPresenter"
    answers = []
    # entry_ids.each { |key, val| answers << key if val.to_i == 1 } # use only checked survey answers

    entries = JournalEntry.find(entry_ids, :include => [ :journal, {:survey => {:scores => [:score_items, :score_refs]}} ] )
    if entries.empty? # if no entries are chosen, show the first three
      entries = Journal.find(journal_id).answered_entries.reverse.slice(0,3)
    end
    survey_answers = entries.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }

    @journal = entries.first.journal # show journal info
    # create survey titles row  # first header is empty, is in corner
    @titles = [""] + survey_answers.map do |sa|
      entry = entries.select { |e| e.survey_answer_id == sa.id }.first
      "#{sa.survey.category} #{sa.survey.age}" # <div class='survey_info'>#{entry.get_follow_up}<br/>#{sa.created_at.strftime('%-d-%-m-%Y')}</div>"
    end

    # find or create score_rapport
    score_rapports = survey_answers.map { |sa| sa.score_rapport ||= sa.generate_score_report }

    first_rapport = score_rapports.first
    data = first_rapport.score_results.inject({}) {|h, res| h[res.title] = [res.result]; h}

    score_rapports[1..-1].each do |rapport|
    	rapport.score_results.inject(data) do |h, sr|
	    	h[sr.title] << sr.result
    		h
    	end
    end

    info_group = []

    age_when_answered = ["Alder"]
    score_rapports.each do |score_rapport|  # age when answered
      report = ScoreReport.new
      report.result = score_rapport.age
      report.percentile = "info"
      age_when_answered << report
    end
    info_group << age_when_answered


    answer_date = ["Besvarelsesdato"]
    answer_date = score_rapports.inject(["Besvarelsesdato"]) do |col, sc|
      #  survey_answers.inject(["Besvarelsesdato"]) do |col, sa|
      report = ScoreReport.new
      created = sc.created_at
      # created = sa.csv_survey_answer.created_at if sa.csv_survey_answer
      report.result = created.strftime('%-d-%-m-%Y')
      report.percentile = "info"
      col << report
    end
    info_group << answer_date

    follow_ups = ["Opfølgning"]
    survey_answers.map do |sa|
      entry = entries.select { |e| e.survey_answer_id == sa.id }.first
      report = ScoreReport.new
      report.result = entry.get_follow_up
      report.percentile = "info"
      follow_ups << report
    end
    info_group << follow_ups

    # TODO: besvarelsesdato

    # holds scores in groups of standard, latent, cross-informant
    @groups = []
    @scales = ScoreScale.find(:all, :order => :position)

    @scales.each do |scale|
      cols = []           # holds columns of results
      score_rapports.each do |score_rapport| # get scores for current scale
        score_results = score_rapport.score_results.select { |s| s.score_scale_id == scale.id }.sort_by { |s| s.position }
        cols << score_results.map { |result| result.to_report }
      end

      rows = cols.fill_2d.transpose
      # add header and left column of score titles
      score_names = rows.collect do |row|
        title_row = row.detect {|r| r}
        if title_row && title_row.title
          title_row.title
        else
          "tom"
        end
      end # get score.scale from first of each column
      rows.each { |row| row.insert(0, score_names.shift) }  # insert score_item names in first column
      @groups << rows
    end

    # first group is info age_when_answered, follow_ups etc
    @groups.insert(0, info_group)
    @groups << [unanswered] # add unanswered row
    @group_titles = ScoreScale.all.map {|scale| "" } #scale.title}
    @group_titles[0] = ""  # do not show standard title

    return self
  end

end
