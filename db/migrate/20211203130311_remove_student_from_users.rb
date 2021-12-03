class RemoveStudentFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :student, :boolean
  end
end
