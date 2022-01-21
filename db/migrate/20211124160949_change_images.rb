class ChangeImages < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    safety_assured { remove_column :images, :profile_picture, :boolean }
    add_column :images, :position, :integer, default: 0

    add_index :images, [:position, :user_id], unique: true, algorithm: :concurrently
  end
end
