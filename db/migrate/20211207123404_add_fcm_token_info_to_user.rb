class AddFcmTokenInfoToUser < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      add_column :users, :fcm, :json, default: {}
    end
  end
end
