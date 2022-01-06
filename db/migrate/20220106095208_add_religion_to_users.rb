class AddReligionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :religion
  end
end
