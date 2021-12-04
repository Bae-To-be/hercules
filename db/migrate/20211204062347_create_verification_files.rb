class CreateVerificationFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :verification_files do |t|
      t.integer :file_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
      t.index [:user_id, :file_type], unique: true
    end
  end
end
