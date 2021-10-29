# frozen_string_literal: true

module RailsAdmin
  module Config
    module Fields
      module Types
        class GenderList < RailsAdmin::Config::Fields::Types::String
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :options_for_select do
            User::GENDERS.keys
          end

          register_instance_option(:partial) do
            :array_input
          end
        end
      end
    end
  end
end
