class AddExercisePreferenceToUser < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :users, :exercise_preference
  end
end
