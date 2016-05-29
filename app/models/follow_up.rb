class FollowUp

  def self.get
    [["Diagnose", 0], ["1. opfølgning", 1], ["2. opfølgning", 2], ["3. opfølgning", 3], ["Afslutning", 4]]
  end

  def self.to_value(num)
  	self.get[num].first
  end
end