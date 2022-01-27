class AddUniquenessToUserReports < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :user_reports, [:from_id, :for_id], unique: true, algorithm: :concurrently
  end
end
