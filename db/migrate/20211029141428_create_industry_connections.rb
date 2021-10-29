class CreateIndustryConnections < ActiveRecord::Migration[7.0]
  def change
    create_view :industry_connections
  end
end
