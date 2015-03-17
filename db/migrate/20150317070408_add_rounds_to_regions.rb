class AddRoundsToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :rounds, :integer
  end
end
