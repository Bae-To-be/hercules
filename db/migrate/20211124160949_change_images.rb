class ChangeImages < ActiveRecord::Migration[7.0]
  def change
    remove_column :images, :profile_picture, :boolean
    add_column :images, :position, :integer, default: 0

    add_index :images, [:position, :user_id], unique: true
  end
end
