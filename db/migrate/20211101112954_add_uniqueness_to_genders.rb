class AddUniquenessToGenders < ActiveRecord::Migration[7.0]
  def change
    add_index :genders, :name, unique: true
  end
end
