class CreateAdminUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_users do |t|
      t.string :google_id, null: false
      t.string :email, null: false
      t.integer :role, default: 0

      t.timestamps
      t.index :google_id, unique: true
      t.index :email, unique: true
    end
  end
end
