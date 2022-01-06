# frozen_string_literal: true

class ChildrenPreference < ApplicationRecord
  has_many :users,
           inverse_of: :children_preference

  def to_h
    {
      id: id,
      name: name
    }
  end
end
