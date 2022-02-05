# frozen_string_literal: true

require 'nested_form/engine'
require 'nested_form/builder_mixin'
require_relative '../../lib/rails_admin/maps'

RailsAdmin.config do |config|
  config.parent_controller = '::ApplicationController'
  config.audit_with :paper_trail, 'AdminUser', 'PaperTrail::Version'

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

    configure :user_updates do
      read_only true
    end

    configure :user_linkedin_url do
      read_only true
    end

    configure :user_selfie_verification_file, :active_storage do
      read_only true
    end

    configure :user_identity_verification_file, :active_storage do
      read_only true
    end

    configure :other_verifications_for_user do
      read_only true
    end

    configure :user_kyc_info do
      read_only true

      label 'Information Submitted'
    end

    configure :user_images_for_verification, :multiple_active_storage do
      read_only true

      label 'Images'
    end

    list do
      field :user
      field :status
      field :created_at
      field :updated_at
    end
  end

  config.model 'Education' do
    object_label_method do
      :pretty_name
    end
  end

  config.model 'UserReport' do
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
    %i[swipes_performed swipes_received selfie_verification identity_verification verification_requests].each do |hidden_field|
      configure hidden_field do
        hide
      end
    end

    configure :fcm do
      queryable false
    end
  end

  config.model 'PaperTrail::Version' do
    visible false
  end

  config.model 'PaperTrail::VersionAssociation' do
    visible false
  end

  %w[
    User
    Education
    VerificationFile
    Image
  ].each do |model|
    config.model model do
      navigation_label 'User Profile'
    end
  end

  %w[
    AdminUser
    Article
    UserReportReason
  ].each do |model|
    config.model model do
      navigation_label 'Others'
    end
  end

  %w[
    UserReport
    VerificationRequest
  ].each do |model|
    config.model model do
      navigation_label 'KYC'
    end
  end

  config.model 'Article' do
    configure :content do
      js_location { bindings[:view].asset_pack_path 'action_text.js' }
    end
  end

  %w[
    IndustryRelationship
    WorkTitleRelationship
    CourseRelationship
  ].each do |model|
    config.model model do
      navigation_label 'Entity Relations'
    end
  end

  %w[City
     Company
     Language
     Course
     University
     Industry
     Company
     WorkTitle
     Religion
     Gender
     DrinkingPreference
     SmokingPreference
     FoodPreference
     ChildrenPreference].each do |model|
    config.model model do
      navigation_label 'Background Information'
    end
  end

  audited_models = ['User', 'Image', 'VerificationFile', 'Education', 'VerificationRequest']
  config.actions do
    dashboard
    maps
    index
    new do
      except 'VerificationRequest'
    end
    bulk_delete
    show
    edit
    delete
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
    UserLanguage
    Swipe
    RefreshToken
    ActionText::RichText
    ActionText::EncryptedRichText
    Message
    Match
    MatchStore
  ]
end
