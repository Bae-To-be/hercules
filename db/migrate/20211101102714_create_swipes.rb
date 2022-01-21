class CreateSwipes < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      create_table :swipes do |t|
        t.references :from, null: false, foreign_key: { to_table: :users }, index: true
        t.references :to, null: false, foreign_key: { to_table: :users }, index: true
        t.integer :direction, null: false

        t.index [:from_id, :to_id], unique: true

        t.timestamps
      end
    end
  end
end
