class Float
  def to_danish
    ciphers = self.to_s.split(".")
    return ciphers[0] + "," + ciphers[1]
  end
end


# def cache_fetch(key, options = {}, &block)
#   if Rails.env.production? 
#     Rails.cache.fetch key, options, &block
#   else
#     yield
#   end
# end