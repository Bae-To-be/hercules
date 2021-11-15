class AddCountryCodeAndLocalityToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :country_code, :string
    add_column :users, :locality, :string
  end
end
