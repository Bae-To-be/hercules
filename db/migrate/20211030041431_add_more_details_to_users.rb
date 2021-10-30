class AddMoreDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :industry, index: true
    add_reference :users, :course, index: true
    add_reference :users, :company, index: true
    add_reference :users, :work_title, index: true
    add_reference :users, :university, index: true
  end
end
