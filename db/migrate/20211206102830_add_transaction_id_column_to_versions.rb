# This migration and CreateVersionAssociations provide the necessary
# schema for tracking associations.
class AddTransactionIdColumnToVersions < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :versions, :transaction_id, :integer
    add_index :versions, [:transaction_id], algorithm: :concurrently
  end
end
