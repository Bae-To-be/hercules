class AddPgTrgmExtensionToDb < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      execute "create extension pg_trgm;"
    end
  end
end
