# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      class Maps < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end

        register_instance_option :controller do
          proc do
            @users = User.all
          end
        end
      end
    end
  end
end
