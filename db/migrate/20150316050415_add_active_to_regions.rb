class AddActiveToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :active, :boolean
  end
end
