class AddSeenToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :seen, :boolean
  end
end
