class AddUniquenessToGenders < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :genders, :name, unique: true, algorithm: :concurrently
  end
end
