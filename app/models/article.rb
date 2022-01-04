# frozen_string_literal: true

class Article < ApplicationRecord
  has_rich_text :content

  def to_h
    {
      id: id,
      title: title
    }
  end
end
