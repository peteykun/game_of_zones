class AddTestedToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :tested, :boolean
  end
end
