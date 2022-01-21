class AddHometownToUser < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_reference :users, :hometown_city, foreign_key: { to_table: :cities } }
    add_column :users, :hometown_country, :string
  end
end
