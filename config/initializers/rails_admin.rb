# frozen_string_literal: true

require 'nested_form/engine'
require 'nested_form/builder_mixin'

RailsAdmin.config do |config|
  config.parent_controller = 'ApplicationController'
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'

  config.current_user_method do
    current_user
  end

  config.authenticate_with do
    redirect_to main_app.admin_login_path if cookies.signed[:user_id].blank?
  end

  config.authorize_with :cancancan

  config.model 'Gender' do
    configure :user_gender_interests do
      hide
    end
  end

  config.model 'VerificationRequest' do
    configure :user do
      read_only true
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

  config.model 'PaperTrail::Version' do
    visible false
  end

  config.model 'PaperTrail::VersionAssociation' do
    visible false
  end

  audited_models = ['User', 'Image', 'VerificationFile', 'Education']
  config.actions do
    dashboard
    index
    new do
      except 'VerificationRequest'
    end
    bulk_delete
    show
    edit
    delete do
      except 'VerificationRequest'
    end
    show_in_app
    history_index do
      only audited_models
    end
    history_show do
      only audited_models
    end
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
