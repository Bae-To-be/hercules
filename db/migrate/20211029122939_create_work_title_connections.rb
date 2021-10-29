class CreateWorkTitleConnections < ActiveRecord::Migration[7.0]
  def change
    create_view :work_title_connections
  end
end
