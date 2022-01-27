class CreateUserReports < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      create_table :user_reports do |t|
        t.references :from, null: false, foreign_key: { to_table: :users }
        t.references :for, null: false, foreign_key: { to_table: :users }
        t.references :user_report_reason, null: false, foreign_key: true
        t.text :comment

        t.timestamps
      end
    end
  end
end
