class AddStudentToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :student, :boolean, default: false
  end
end
