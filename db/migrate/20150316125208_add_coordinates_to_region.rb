class AddCoordinatesToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :x, :integer
    add_column :regions, :y, :integer
  end
end
