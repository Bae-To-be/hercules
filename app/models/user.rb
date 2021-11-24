# frozen_string_literal: true

class User < ApplicationRecord
  include PgSearch::Model
  acts_as_mappable

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

  has_many :images, dependent: :destroy

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

  has_one :profile_picture,
          -> { where(profile_picture: true) },
          class_name: 'Image'

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
      student: student,
      interested_genders: interested_genders.map(&:name),
      education: educations.map(&:to_h),
      linkedin_url: linkedin_url,
      linkedin_public: linkedin_public
    }
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
      student: student,
      profile_picture: profile_picture&.url,
      education: educations.map(&:to_h)
    }
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
end
