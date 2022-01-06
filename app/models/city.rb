class City < ApplicationRecord
  include PgSearch::Model

  validates :name,
            presence: true,
            uniqueness: true

  has_many :users,
           foreign_key: :hometown_city_id,
           inverse_of: :city

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
