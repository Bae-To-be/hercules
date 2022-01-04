# frozen_string_literal: true

class Article < ApplicationRecord
  has_rich_text :content
end
