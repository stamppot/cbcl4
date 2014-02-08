module Enumerable
  def foldr(o, m = nil)
    reverse.inject(m) {|m, i| m ? i.send(o, m) : i}
  end

  def foldl(o, m = nil)
    inject(m) {|m, i| m ? m.send(o, i) : i}
  end

  def build_hash
    is_hash = false
    inject({}) do |target, element|
      key, value = yield(element)
      is_hash = true if !is_hash && value.is_a?(Hash)
      if is_hash
        target[key] = {} unless target[key]
        target[key].merge! value
      else
        target[key] = [] unless target[key]
        target[key] << value
      end
      target
    end
  end

  def dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
  end

  # creates a hash with elem as key, result of block as value
  # def to_hash
  #   result = {}
  #   each do |elt|
  #     if block_given?
  #       result[elt] = yield(elt)
  #     else
  #       result[elt] = elt
  #     end
  #   end
  #   result
  # end
  
  # creates a hash with result of block as key, elem as value
  def to_hash_with_key
    result = {}
    each do |elt|
      result[yield(elt)] = elt
    end
    result
  end

  def collect_if(condition)
    inject([]) do |target, element|
      value = yield(element)
      target << value if element.send(condition) #eval("element.#{condition}")
      target
    end
  end
end