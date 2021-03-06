class ScoreChartPresenter

  attr_accessor :journal, :title, :titles, :groups, :scales, :group_titles

  def build(answers, journal_id, entries)

    # entries = JournalEntry.find(answers, :include => [ :journal, {:survey => {:scores => [:score_items, :score_refs]}} ] )
    # # if no entries are chosen, show the first three
    # if entries.empty? 
    #   entries = Journal.find(journal_id).answered_entries.reverse.slice(0,3)
    # end
    survey_answers = entries.sort_by {|e| e.follow_up }.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }

    @journal = entries.first.journal # show journal info
    # create survey titles row  # first header is empty, is in corner
    @titles = [""] + survey_answers.map do |sa|
      entry = entries.select { |e| e.survey_answer_id == sa.id }.first
      "#{sa.survey.category} #{sa.survey.age}" # <div class='survey_info'>#{entry.get_follow_up}<br/>#{sa.created_at.strftime('%-d-%-m-%Y')}</div>"
    end

    # find or create score_rapport
    score_rapports = survey_answers.map { |sa| sa.score_rapport ||= sa.generate_score_report }
    # unanswered = ["Ubesvarede"]
    # score_rapports.each do |score_rapport|  # find no unanswered
    #   report = ChartScoreGroup.new
    #   report.result = score_rapport.unanswered
    #   report.percentile = "&nbsp;"
    #   unanswered << report
    # end

    @groups = score_rapports.inject([]) do |col, sc|
      results = sc.score_results.sort_by {|sr| sr.position }
      csg = ChartScoreGroup.new
      csg.title = sc.short_name
      csg.description = sc.survey_name
      csg.titles = results.map { |sr| sr.title }
      csg.scores = results.map { |sr| sr.result }
      csg.period = FollowUp.get[sc.follow_up || 0].first
      col << csg
      col
    end


    # info_group = []

    # age_when_answered = ["Alder"]
    # score_rapports.each do |score_rapport|  # age when answered
    #   report = ScoreReport.new
    #   report.result = score_rapport.age
    #   report.percentile = "info"
    #   age_when_answered << report
    # end
    # info_group << age_when_answered


    # answer_date = ["Besvarelsesdato"]
    # answer_date = score_rapports.inject(["Besvarelsesdato"]) do |col, sc|
    #   #  survey_answers.inject(["Besvarelsesdato"]) do |col, sa|
    #   report = ScoreReport.new
    #   created = sc.created_at
    #   # created = sa.csv_survey_answer.created_at if sa.csv_survey_answer
    #   report.result = created.strftime('%-d-%-m-%Y')
    #   report.percentile = "info"
    #   col << report
    # end
    # info_group << answer_date

    # follow_ups = ["Opfølgning"]
    # survey_answers.map do |sa|
    #   entry = entries.select { |e| e.survey_answer_id == sa.id }.first
    #   report = ScoreReport.new
    #   report.result = entry.get_follow_up
    #   report.percentile = "info"
    #   follow_ups << report
    # end
    # info_group << follow_ups

    # TODO: besvarelsesdato

    # holds scores in groups of standard, latent, cross-informant
    # @groups = []
    # @scales = ScoreScale.find(:all, :order => :position)

    # @scales.each do |scale|
    #   cols = []           # holds columns of results
    #   score_rapports.each do |score_rapport| # get scores for current scale
    #     score_results = score_rapport.score_results.select { |s| s.score_scale_id == scale.id }.sort_by { |s| s.position }
    #     cols << score_results.map { |result| result.to_report }
    #   end

    #   rows = cols.fill_2d.transpose
    #   # add header and left column of score titles
    #   score_names = rows.collect do |row|
    #     title_row = row.detect {|r| r}
    #     if title_row && title_row.title
    #       title_row.title
    #     else
    #       "tom"
    #     end
    #   end # get score.scale from first of each column
    #   rows.each { |row| row.insert(0, score_names.shift) }  # insert score_item names in first column
    #   @groups << rows
    # end

    # first group is info age_when_answered, follow_ups etc
    # @groups.insert(0, info_group)
    # @groups << [unanswered] # add unanswered row
    # @group_titles = ScoreScale.all.map {|scale| "" } #scale.title}
    # @group_titles[0] = ""  # do not show standard title

    return self
  end

end