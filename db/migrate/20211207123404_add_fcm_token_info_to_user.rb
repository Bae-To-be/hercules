class AddFcmTokenInfoToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :fcm, :json, default: {}
  end
end
