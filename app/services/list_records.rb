# frozen_string_literal: true

class ListRecords
  def initialize(model, search_scope, query)
    @model = model
    @search_scope = search_scope
    @query = query
  end

  def run
    ServiceResponse.ok(
      model.public_send(search_scope, query).map(&:to_h)
    )
  end

  private

  attr_reader :model, :search_scope, :query
end
