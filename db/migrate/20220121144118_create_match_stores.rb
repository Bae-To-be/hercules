class CreateMatchStores < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      create_table :match_stores do |t|
        t.references :source, null: false, foreign_key: {  to_table: :users  }
        t.references :target, null: false, foreign_key: false

        t.timestamps
        t.index "(ARRAY[least(source_id, target_id), greatest(target_id, source_id)])",
                unique: true,
                name: :match_store_pair_uniq
      end
    end
  end
end
