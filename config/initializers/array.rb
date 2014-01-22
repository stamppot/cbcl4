# http://mspeight.blogspot.com/2007/06/better-groupby-ingroupsby-for.html
class Array

  def in_groups_by
    # Group elements into individual array's by the result of a block
    # Similar to the in_groups_of function.
    # NOTE: assumes array is already ordered/sorted by group !!
    curr=nil.class 
    result=[]
    each do |element|
      group=yield(element) # Get grouping value
      result << [] if curr != group # if not same, start a new array
      curr = group
      result[-1] << element
    end
    result
  end

  # fill 2-d array so all rows has equal number of items
  def fill_2d(obj = nil)
    # find longest
    longest = self.max { |a,b| a.length <=> b.length }.size
    self.each do |row|
      row[longest-1] = obj if row.size < longest  # fill with nulls
    end
    return self
  end

  def to_h
    Hash[*self]
  end

  def to_hash_flat
    is_hash = false
    inject({}) do |target, element|
      key, value = yield(element)
      target[key] = value
      target
    end
  end

end