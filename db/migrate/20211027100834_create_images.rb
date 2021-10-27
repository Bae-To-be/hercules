class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.boolean :profile_picture, default: false
      t.references :user

      t.timestamps
    end
  end
end
