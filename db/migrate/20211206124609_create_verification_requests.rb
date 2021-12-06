class CreateVerificationRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :verification_requests do |t|
      t.integer :status, default: 0
      t.boolean :linkedin_approved, default: false
      t.boolean :work_details_approved, default: false
      t.boolean :education_approved, default: false

      t.boolean :identity_approved, default: false
      t.boolean :selfie_approved, default: false
      t.boolean :dob_approved, default: false

      t.string :rejection_reason
      t.references :user

      t.timestamps
    end
  end
end
