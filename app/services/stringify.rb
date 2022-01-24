# frozen_string_literal: true

class Stringify
  class << self
    def hash_values(map)
      map.transform_values(&method(:value))
    end

    def value(value)
      case value
      when Hash
        hash_values(value)
      when Array
        value.map(&method(:value))
      else
        value.to_s
      end
    end
  end
end
