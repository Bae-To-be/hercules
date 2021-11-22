# frozen_string_literal: true

require 'nested_form/engine'
require 'nested_form/builder_mixin'

RailsAdmin.config do |config|
  config.authorize_with do
    authenticate_or_request_with_http_basic('Login required') do |username, password|
      username == ENV.fetch('ADMIN_USERNAME') &&
        password == ENV.fetch('ADMIN_PASSWORD')
    end
  end

  config.model 'Gender' do
    configure :user_gender_interests do
      hide
    end
  end

  config.model 'Education' do
    object_label_method do
      :pretty_name
    end
  end

  ['WorkTitle', 'Course', 'Industry'].each do |connected|
    config.model connected do
      configure "#{connected.underscore}_connections".to_sym do
        hide
      end

      configure :source_relations do
        hide
      end

      configure :target_relations do
        hide
      end

      edit do
        configure "related_#{connected.underscore.pluralize}".to_sym do
          hide
        end
      end

      create do
        configure :related_work_titles do
          hide
        end
      end
    end
  end

  config.model 'User' do
    configure :swipes_performed do
      hide
    end

    configure :swipes_received do
      hide
    end
  end

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.excluded_models = %w[
    ActiveStorage::Blob
    ActiveStorage::Attachment
    ActiveStorage::VariantRecord
    WorkTitleConnection
    CourseConnection
    IndustryConnection
    UserGenderInterest
    Swipe
    RefreshToken
  ]
end
