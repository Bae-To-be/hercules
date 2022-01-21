class CreateCourseRelationships < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      create_table :course_relationships do |t|
        t.references :source, null: false, foreign_key: { to_table: :courses }
        t.references :target, null: false, foreign_key: { to_table: :courses }

        t.timestamps
      end

      add_index :course_relationships,
                "(ARRAY[least(source_id, target_id), greatest(target_id, source_id)])",
                unique: true,
                name: :course_pair_uniq
    end
  end
end
