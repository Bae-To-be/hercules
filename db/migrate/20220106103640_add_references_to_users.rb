class AddReferencesToUsers < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :users, :food_preference
    add_reference_concurrently :users, :drinking_preference
    add_reference_concurrently :users, :smoking_preference
    add_reference_concurrently :users, :children_preference
  end
end
