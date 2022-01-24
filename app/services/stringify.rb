class Stringify
  class << self
    def hash_values(map)
      map.transform_values(&method(:stringify_value))
    end

    def value(value)
      if value.is_a? Hash
        hash_values(map)
      elsif value.is_a? Array
        value.map do |item|
          value(item)
        end
      else
        value.to_s
      end
    end
  end
end