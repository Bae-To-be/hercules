class CreateGenders < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :genders do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    add_reference_concurrently :users, :gender, index: true
  end
end
