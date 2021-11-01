class AddDateRangeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :interested_age_lower, :integer
    add_column :users, :interested_age_upper, :integer
  end
end
