class CreateGenders < ActiveRecord::Migration[7.0]
  def change
    create_table :genders do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    add_reference :users, :gender, index: true
  end
end
