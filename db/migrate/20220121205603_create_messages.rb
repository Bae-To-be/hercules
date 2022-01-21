class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      enable_extension 'pgcrypto'

      create_table :messages, id: :uuid do |t|
        t.references :match_store, null: false, foreign_key: true
        t.text :content
        t.references :author, null: false, foreign_key: {  to_table: :users }

        t.timestamps
      end
    end
  end
end
