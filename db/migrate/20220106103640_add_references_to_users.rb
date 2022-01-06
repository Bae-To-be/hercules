class AddReferencesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :food_preference
    add_reference :users, :drinking_preference
    add_reference :users, :smoking_preference
    add_reference :users, :children_preference
  end
end
