class RemoveUniqueIndexFromUserGenderInterests < ActiveRecord::Migration[7.0]
  def change
    remove_index :user_gender_interests, name: 'index_user_gender_interests_on_user_id_and_gender_id'
  end
end
