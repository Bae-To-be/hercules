# frozen_string_literal: true

class UserLanguage < ApplicationRecord
  belongs_to :user
  belongs_to :language
end
