# frozen_string_literal: true

class User < ApplicationRecord
  extend ArrayEnum

  GENDERS = {
    'male' => 0,
    'female' => 1,
    'agender' => 3,
    'androgynous' => 4,
    'bigender' => 5,
    'gender fluid' => 6,
    'gender nonconforming' => 7,
    'gender questioning' => 8,
    'genderqueer' => 9,
    'non binary' => 10,
    'female to male' => 11,
    'male to female' => 12,
    'other' => 13,
    'pangender' => 14,
    'trans*' => 15,
    'trans man' => 16,
    'trans person' => 17,
    'transfeminine' => 18,
    'transgender' => 19,
    'transmesculine' => 20,
    'transsexual' => 21,
    'hijra' => 22,
    'intersex' => 23,
    'kothi' => 24
  }.freeze

  enum gender: GENDERS
  array_enum interested_in: GENDERS

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :gender, presence: true

  has_many :images, dependent: :destroy

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

  def to_h
    {
      name: name,
      gender: gender,
      interested_in: interested_in,
      birthday: birthday.strftime('%d-%m-%Y'),
      profile_picture: profile_picture&.url
    }
  end
end
