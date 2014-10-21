class ChartScoreGroup

	attr_accessor :titles, :scores, :period, :title, :description

  def initialize
    @titles = []
    @scores = []
    @survey_name = ""
    @short_name = ""
    @period = ""
    @title = ""
    @percentile = "93%"
    @description = ""
  end


end