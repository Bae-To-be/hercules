class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.integer :gender, null: true
      t.integer :interested_in, array: true, default: []

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :gender
    add_index :users, :interested_in
  end
end
