# frozen_string_literal: true

class Religion < ApplicationRecord
  include PgSearch::Model

  validates :name,
            presence: true,
            uniqueness: true

  has_many :users,
           inverse_of: :religion

  pg_search_scope :search_by_name,
                  against: :name,
                  using: :trigram

  def to_h
    {
      id: id,
      name: name
    }
  end
end
