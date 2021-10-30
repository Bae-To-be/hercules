# frozen_string_literal: true

class User < ApplicationRecord
  extend ArrayEnum

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

  delegate :name,
           to: :course,
           allow_nil: true,
           prefix: true

  delegate :name,
           to: :industry,
           allow_nil: true,
           prefix: true

  delegate :name,
           to: :gender,
           allow_nil: true,
           prefix: true

  delegate :name,
           to: :company,
           allow_nil: true,
           prefix: true

  delegate :name,
           to: :university,
           allow_nil: true,
           prefix: true

  delegate :name,
           to: :work_title,
           allow_nil: true,
           prefix: true

  def to_h
    {
      name: name,
      course: course_name,
      gender: gender_name,
      industry: industry_name,
      company: company_name,
      university: university_name,
      work_title: work_title_name,
      birthday: birthday.strftime('%d-%m-%Y'),
      profile_picture: profile_picture&.url
    }
  end
end
