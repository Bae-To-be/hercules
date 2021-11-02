class AddSearchRadiusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :search_radius, :integer, default: 0
  end
end
