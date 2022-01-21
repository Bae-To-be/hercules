# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :user,
             class_name: 'User'
  belongs_to :matched_user,
             class_name: 'User'
end
