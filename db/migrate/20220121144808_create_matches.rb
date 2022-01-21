class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_view :matches
  end
end
