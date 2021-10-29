class CreateWorkTitleRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :work_title_relationships do |t|
      t.references :source, null: false, foreign_key: { to_table: :work_titles }
      t.references :target, null: false, foreign_key: { to_table: :work_titles }

      t.timestamps
    end

    add_index :work_title_relationships,
      "(ARRAY[least(source_id, target_id), greatest(target_id, source_id)])",
      unique: true,
      name: :work_title_pair_uniq
  end
end
