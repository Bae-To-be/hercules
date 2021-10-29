# frozen_string_literal: true

class IndustryConnection < ApplicationRecord
  belongs_to :industry
  belongs_to :related_industry,
             class_name: 'Industry'
end
