# frozen_string_literal: true

class University < ApplicationRecord
  include PgSearch::Model
  validates :name,
            presence: true,
            uniqueness: true

  has_many :users,
           inverse_of: :university

  pg_search_scope :search_by_name,
                  against: :name,
                  using: [:tsearch, :trigram]

  def to_h
    {
      id: id,
      name: name
    }
  end
end
