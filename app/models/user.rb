# frozen_string_literal: true

class User < ApplicationRecord
  include PgSearch::Model

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true

  has_many :images, dependent: :destroy

  has_many :user_gender_interests,
           inverse_of: :user,
           dependent: :destroy

  has_many :interested_genders,
           through: :user_gender_interests,
           source: :gender

  has_many :swipes_performed,
           class_name: 'Swipe',
           inverse_of: :from

  has_many :swipes_received,
           class_name: 'Swipe',
           inverse_of: :to

  has_one :profile_picture,
          -> { where(profile_picture: true) },
          class_name: 'Image'

  belongs_to :course,
             optional: true,
             inverse_of: :users

  belongs_to :industry,
             optional: true,
             inverse_of: :users

  belongs_to :company,
             optional: true,
             inverse_of: :users

  belongs_to :work_title,
             optional: true,
             inverse_of: :users

  belongs_to :university,
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

  def student?
    company_id.nil?
  end

  def to_h
    {
      id: id,
      name: name,
      course: course&.name,
      gender: gender&.name,
      industry: industry&.name,
      company: company&.name,
      university: university&.name,
      work_title: work_title&.name,
      birthday: birthday.strftime('%d-%m-%Y'),
      age: current_age,
      profile_picture: profile_picture&.url
    }
  end

  def current_age
    years = Time.now.utc.to_date.year - birthday.year
    years += 1 if Time.now.utc.to_date.month < birthday.month

    if Time.now.utc.to_date.month == birthday.month &&
       Time.now.utc.to_date.day < dob.day
      years -= 1
    end

    years
  end
end
