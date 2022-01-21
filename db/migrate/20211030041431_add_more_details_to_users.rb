class AddMoreDetailsToUsers < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :users, :industry, index: true
    add_reference_concurrently :users, :course, index: true
    add_reference_concurrently :users, :company, index: true
    add_reference_concurrently :users, :work_title, index: true
    add_reference_concurrently :users, :university, index: true
  end
end
