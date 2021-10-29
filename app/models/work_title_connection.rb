# frozen_string_literal: true

class WorkTitleConnection < ApplicationRecord
  belongs_to :work_title
  belongs_to :related_work_title,
             class_name: 'WorkTitle'
end
