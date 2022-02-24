# frozen_string_literal: true

class User < ApplicationRecord
  include PgSearch::Model
  acts_as_mappable
  acts_as_reader
  has_paper_trail ignore: %i[fcm updated_at created_at last_logged_in]

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

  validates :bio,
            length: { maximum: 500 },
            allow_nil: true

  validates :height_in_cms,
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

  enum status: { active: 0, paused: 1 }

  has_many :images, dependent: :destroy, inverse_of: :user
  has_many :verification_files, dependent: :destroy, inverse_of: :user
  has_one :selfie_verification,
          -> { where(file_type: :selfie) },
          class_name: 'VerificationFile'
  has_one :identity_verification,
          -> { where(file_type: :identity) },
          class_name: 'VerificationFile'

  has_many :verification_requests, dependent: :destroy, inverse_of: :user

  has_one :last_verification,
          -> { order(id: :desc) },
          class_name: 'VerificationRequest'

  has_many :educations, dependent: :destroy, inverse_of: :user

  has_many :reports_filed,
           class_name: 'UserReport',
           foreign_key: 'from_id',
           inverse_of: :from,
           dependent: :destroy

  has_many :reports_received,
           class_name: 'UserReport',
           foreign_key: 'for_id',
           inverse_of: :for_user,
           dependent: :destroy

  has_many :user_gender_interests,
           inverse_of: :user,
           dependent: :destroy

  has_many :interested_genders,
           through: :user_gender_interests,
           source: :gender

  has_many :user_languages,
           inverse_of: :user,
           dependent: :destroy

  has_many :languages,
           through: :user_languages,
           inverse_of: :users

  has_many :swipes_performed,
           class_name: 'Swipe',
           inverse_of: :from,
           foreign_key: :from_id,
           dependent: :destroy

  has_many :sent_match_stores,
           class_name: 'MatchStore',
           inverse_of: :source,
           foreign_key: :source_id,
           dependent: :destroy

  has_many :received_match_stores,
           class_name: 'MatchStore',
           inverse_of: :target,
           foreign_key: :target_id,
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

  belongs_to :city,
             optional: true,
             foreign_key: :hometown_city_id,
             inverse_of: :users

  belongs_to :religion,
             optional: true,
             inverse_of: :users

  belongs_to :food_preference,
             optional: true,
             inverse_of: :users

  belongs_to :exercise_preference,
             optional: true,
             inverse_of: :users

  belongs_to :children_preference,
             optional: true,
             inverse_of: :users

  belongs_to :drinking_preference,
             optional: true,
             inverse_of: :users

  belongs_to :smoking_preference,
             optional: true,
             inverse_of: :users

  delegate :file, to: :selfie_verification, prefix: true, allow_nil: true
  delegate :file, to: :identity_verification, prefix: true, allow_nil: true

  before_destroy do
    versions.destroy_all
  end

  scope :between_age, lambda { |lower, upper|
    where('birthday BETWEEN ? AND ?',
          Time.now.utc.to_date.advance(years: -upper),
          Time.now.utc.to_date.advance(years: -lower))
  }

  scope :interested_in_genders, lambda { |gender_ids|
    joins(:user_gender_interests)
      .where(user_gender_interests: { gender_id: [gender_ids] })
  }

  scope :exclude_company, lambda { |company_id|
    where.not(company_id: company_id)
  }

  scope :exclude_university, lambda { |university_id|
    where.not(university_id: university_id)
  }

  def search_radius_value
    search_radius.zero? ? ENV.fetch('DEFAULT_SEARCH_RADIUS').to_i : search_radius
  end

  def me_hash
    {
      id: id,
      name: name,
      status: status,
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
      bio: bio,
      hometown: {
        country_name: hometown_country,
        city: city&.to_h
      },
      food_preference: food_preference&.to_h,
      exercise_preference: exercise_preference&.to_h,
      children_preference: children_preference&.to_h,
      smoking_preference: smoking_preference&.to_h,
      drinking_preference: drinking_preference&.to_h,
      height_in_cms: height_in_cms,
      religion: religion&.to_h,
      languages: languages.map(&:to_h),
      search_radius: search_radius_value,
      interested_age_lower: interested_age_lower,
      interested_age_upper: interested_age_upper
    }
  end

  def verification_rejected?
    recent_verification&.rejected?
  end

  def basic_hash(include_picture: true)
    {
      id: id,
      name: name,
      summary: "#{work_title&.name}, #{industry&.name}",
      age: current_age,
      profile_picture: include_picture ? profile_picture&.to_h : nil
    }
  end

  def profile_picture
    images.min_by(&:position)
  end

  def to_h
    {
      id: id,
      name: name,
      gender: gender&.name,
      industry: industry&.name,
      company: company&.name,
      work_title: work_title&.name,
      age: current_age,
      education: educations.includes(:course, :university).map(&:to_h),
      linkedin_url: linkedin_public? ? linkedin_url : '',
      linkedin_public: linkedin_public,
      bio: bio,
      hometown: {
        country_name: hometown_country,
        city: city&.to_h
      },
      food_preference: food_preference&.to_h,
      exercise_preference: exercise_preference&.to_h,
      children_preference: children_preference&.to_h,
      smoking_preference: smoking_preference&.to_h,
      drinking_preference: drinking_preference&.to_h,
      height_in_cms: height_in_cms,
      religion: religion&.to_h,
      languages: languages.map(&:to_h),
      images: images.map(&:to_h)
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
      education: educations.includes(:course, :university).map(&:to_h),
      locality: locality,
      country_code: country_code
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
    if refresh
      @recent_verification = verification_requests.last
      return @recent_verification
    end

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

    ((Time.zone.now - birthday.to_time) / 1.year.seconds).floor
  end

  def images_for_verification
    images.map(&:file)
  end

  def only_meta_updated?
    (changes.keys - %w[lat lng country_code locality]).empty? ||
      (changes.keys - %w[fcm]).empty?
  end

  def location
    {
      lat: lat,
      lng: lng,
      search_radius: search_radius_value,
      gender: gender&.name,
      age: current_age,
      status: last_verification&.status
    }
  end

  def location_present?
    lat.present? && lng.present?
  end
end
