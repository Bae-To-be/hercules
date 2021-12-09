# frozen_string_literal: true

class User < ApplicationRecord
  include PgSearch::Model
  acts_as_mappable
  has_paper_trail

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :lng,
            allow_nil: true,
            numericality: true

  validates :lat,
            allow_nil: true,
            numericality: true

  validates :name, presence: true

  validates :linkedin_url,
            format: { with: Regexp.new('https:\\/\\/[a-z]{2,3}\\.linkedin\\.com\\/.*') },
            allow_blank: true

  validates :birthday,
            inclusion: { in: lambda { |_g|
                               (-Float::INFINITY..(Time.now.utc.to_date - 18.years))
                             }, message: 'cannot be less than 18 years' }, allow_nil: true

  has_many :images, dependent: :destroy, inverse_of: :user
  has_many :verification_files, dependent: :destroy, inverse_of: :user
  has_one :selfie_verification,
          -> { where(file_type: :selfie) },
          class_name: 'VerificationFile'
  has_one :identity_verification,
          -> { where(file_type: :identity) },
          class_name: 'VerificationFile'

  has_many :verification_requests, dependent: :destroy, inverse_of: :user

  has_many :educations, dependent: :destroy, inverse_of: :user

  has_many :user_gender_interests,
           inverse_of: :user,
           dependent: :destroy

  has_many :interested_genders,
           through: :user_gender_interests,
           source: :gender

  has_many :swipes_performed,
           class_name: 'Swipe',
           inverse_of: :from,
           foreign_key: :from_id,
           dependent: :destroy

  has_many :swipes_received,
           class_name: 'Swipe',
           inverse_of: :to,
           foreign_key: :to_id,
           dependent: :destroy

  has_many :refresh_tokens, dependent: :delete_all

  belongs_to :industry,
             optional: true,
             inverse_of: :users

  belongs_to :company,
             optional: true,
             inverse_of: :users

  belongs_to :work_title,
             optional: true,
             inverse_of: :users

  belongs_to :gender,
             optional: true,
             inverse_of: :users

  delegate :file, to: :selfie_verification, prefix: true, allow_nil: true
  delegate :file, to: :identity_verification, prefix: true, allow_nil: true

  scope :between_age, lambda { |lower, upper|
    where('birthday BETWEEN ? AND ?',
          Time.now.utc.to_date.advance(years: -upper),
          Time.now.utc.to_date.advance(years: -lower))
  }

  scope :interested_in_gender, lambda { |gender_id|
    joins(:user_gender_interests)
      .where(user_gender_interests: { gender_id: gender_id })
  }

  scope :exclude_company, lambda { |company_id|
    where.not(company_id: company_id)
  }

  scope :exclude_university, lambda { |university_id|
    where.not(university_id: university_id)
  }

  def search_radius_value
    search_radius.zero? ? ENV.fetch('DEFAULT_SEARCH_RADIUS') : search_radius
  end

  def me_hash
    {
      id: id,
      name: name,
      gender: gender&.name,
      industry: industry&.name,
      company: company&.name,
      work_title: work_title&.name,
      birthday: birthday&.strftime('%d-%m-%Y'),
      age: current_age,
      interested_genders: interested_genders.map(&:name),
      education: educations.includes(:course, :university).map(&:to_h),
      linkedin_url: linkedin_url,
      linkedin_public: linkedin_public,
      approval_status: approval_status,
      verification_details: verification_rejected? ? recent_verification.to_hash : nil
    }
  end

  def verification_rejected?
    recent_verification(refresh: true)&.rejected?
  end

  def approval_status
    recent_verification&.status || VerificationRequest::IN_REVIEW
  end

  def to_h
    {
      id: id,
      name: name,
      gender: gender&.name,
      industry: industry&.name,
      company: company&.name,
      work_title: work_title&.name,
      birthday: birthday&.strftime('%d-%m-%Y'),
      age: current_age,
      education: educations.includes(:course, :university).map(&:to_h)
    }
  end

  def kyc_info
    {
      name: name,
      gender: gender&.name,
      industry: industry&.name,
      company: company&.name,
      work_title: work_title&.name,
      birthday: birthday&.strftime('%d-%m-%Y'),
      education: educations.includes(:course, :university).map(&:to_h)
    }.to_json
  end

  def queue_verification!(check_changes: true)
    # Avoid running if its a location update
    return if check_changes && only_meta_updated?

    if registration_complete? &&
       (verification_requests.blank? ||
        (recent_verification.rejected? &&
          recent_verification.all_fields_rectified?))

      verification_requests.create!
    end
  end

  def recent_verification(refresh: false)
    return verification_requests.last if refresh

    @recent_verification ||= verification_requests.last
  end

  def registration_complete?
    gender_id.present? &&
      industry_id.present? &&
      company_id.present? &&
      educations.present? &&
      birthday.present? &&
      linkedin_url.present? &&
      verification_files.size == 2 &&
      images.size > 1
  end

  def current_age
    return if birthday.blank?

    years = Time.now.utc.to_date.year - birthday.year
    years += 1 if Time.now.utc.to_date.month < birthday.month

    if Time.now.utc.to_date.month == birthday.month &&
       Time.now.utc.to_date.day < birthday.day
      years -= 1
    end

    years
  end

  def images_for_verification
    images.map(&:file)
  end

  def only_meta_updated?
    (changes.keys - %w[lat lng country_code locality]).empty? ||
      (changes.keys - %w[fcm]).empty?
  end
end
