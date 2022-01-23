class AddClientIdToMessages < ActiveRecord::Migration[7.0]

  def change
    add_column :messages, :client_id, :string
  end
end
