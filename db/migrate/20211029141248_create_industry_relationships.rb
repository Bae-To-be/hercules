class CreateIndustryRelationships < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      create_table :industry_relationships do |t|
        t.references :source, null: false, foreign_key: { to_table: :industries }
        t.references :target, null: false, foreign_key: { to_table: :industries }

        t.timestamps
      end

      add_index :industry_relationships,
                "(ARRAY[least(source_id, target_id), greatest(target_id, source_id)])",
                unique: true,
                name: :industry_pair_uniq
    end
  end
end
