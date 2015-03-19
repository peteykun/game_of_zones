class AddPastLevelToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :past_level, :integer
  end
end
