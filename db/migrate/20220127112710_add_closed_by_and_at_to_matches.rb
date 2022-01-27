class AddClosedByAndAtToMatches < ActiveRecord::Migration[7.0]
  def change
    safety_assured { add_reference :match_stores, :closed_by, foreign_key: { to_table: :users } }
    add_column :match_stores, :closed_at, :datetime
  end
end
