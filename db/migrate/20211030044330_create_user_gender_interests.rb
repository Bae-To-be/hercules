class CreateUserGenderInterests < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      create_table :user_gender_interests do |t|
        t.references :user, null: false, foreign_key: true
        t.references :gender, null: false, foreign_key: true

        t.index %i[user_id gender_id], unique: true
        t.timestamps
      end

      remove_column :users, :gender
      remove_column :users, :interested_in
    end
  end
end
