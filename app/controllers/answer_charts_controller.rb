class AnswerChartsController < ApplicationController
  
  layout 'no_menu_jq'
  
  def show
    if params[:answers].nil?
      journal_id = params[:journal_id].to_i
      redirect_to journals(journal_id) and return 
    end

    answers = params[:answers].select {|k,v| v == "1"}.keys
    entries = JournalEntry.includes([:journal, :survey]).find(answers) # {:scores => [:score_items, :score_refs]}} ] )
    journal_id = params[:journal_id]

    # if no entries are chosen, show the first three
    if entries.empty? 
      entries = Journal.find(journal_id).answered_entries.reverse.slice(0,15)
    end

    entries_by_survey = entries.group_by {|e| e.survey} #.order_by {|e| e.survey.title}
    @journal = Journal.find(params[:journal_id])

    @presenters = []
    entries_by_survey.each do |survey, entries|
    # score_report = ScoreReportPresenter.new.build(params[:answers], params[:journal_id])
      score_chart = ScoreChartPresenter.new.build(answers, journal_id, entries)
      titles  = [@journal.title] + score_chart.groups.first.titles #.map {|t| t.gsub("nn", "<br/>")}
      groups  = score_chart.groups
      score_chart.title = survey.title
      group_titles = score_chart.group_titles
      @presenters << score_chart
    end

    entries_by_survey.each do |survey, entries|
      puts "survey: #{survey.title}  e: #{entries.size}"
    end
    # puts "entries_by_survey: #{entries_by_survey.keys.map{|s| s.title}}"

    # puts "presenters: #{@presenters.inspect}"

    # puts "titles: #{@titles.inspect}"
    # puts "group_titles: #{@group_titles.inspect}"
    @journal_name = @journal.title

    
    @page_title = "CBCL - Svargrafik: " << @journal.title
    # render 'show'
  end 
end
