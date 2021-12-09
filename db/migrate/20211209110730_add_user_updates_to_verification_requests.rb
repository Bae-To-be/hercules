class AddUserUpdatesToVerificationRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :verification_requests, :user_updates, :text, array: true, default: []
  end
end
