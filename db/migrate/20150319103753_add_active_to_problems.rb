class AddActiveToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :active, :boolean
  end
end
