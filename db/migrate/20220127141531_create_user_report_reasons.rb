class CreateUserReportReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :user_report_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end
