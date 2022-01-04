class AddPositionToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :position, :integer
    add_index :articles, :position, unique: true
  end
end
