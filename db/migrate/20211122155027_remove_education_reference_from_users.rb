class RemoveEducationReferenceFromUsers < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      remove_column :users, :university_id
      remove_column :users, :course_id
    end
  end
end
