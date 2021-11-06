module Auth
  module Strategies
    class Base
      def initialize(token)
        @token = token
      end

      def email_id
        raise "Implement #email in #{self.class.name}"
      end

      def main_attributes
        raise "Implement #main_attributes in #{self.class.name}"
      end

      def attributes_to_update
        raise "Implement #attributes_to_update in #{self.class.name}"
      end

      def image_url
        raise "Implement #image_url in #{self.class.name}"
      end

      private 

      attr_reader :token
    end
  end
end