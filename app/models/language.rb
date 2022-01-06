# frozen_string_literal: true

class Language < ApplicationRecord
  has_many :user_languages,
           inverse_of: :language,
           dependent: :destroy

  has_many :users,
           through: :user_languages,
           inverse_of: :languages

  def to_h
    {
      id: id,
      name: name
    }
  end
end
