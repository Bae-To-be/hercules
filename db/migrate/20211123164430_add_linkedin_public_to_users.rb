class AddLinkedinPublicToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :linkedin_public, :boolean, default: false
  end
end
