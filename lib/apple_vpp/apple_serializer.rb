module AppleVPP
  class AppleSerializer
    
    def self.to_ruby(apple_hash)
      if apple_hash.kind_of?( Array )
        return apple_hash.collect { |i| to_ruby i }
      end
      
      keys_with_hashes = apple_hash.select { | _k, v | v.kind_of?( Hash ) }

      if keys_with_hashes.count > 0
        keys_with_hashes.each { |k, v| apple_hash[k] = to_ruby v }
      end

      Hash[ apple_hash.map { | k, v | [ k.underscore.to_sym, v ] } ]
    end

  end
end