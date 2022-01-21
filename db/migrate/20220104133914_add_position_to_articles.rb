class AddPositionToArticles < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :articles, :position, :integer
    add_index :articles, :position, unique: true, algorithm: :concurrently
  end
end
