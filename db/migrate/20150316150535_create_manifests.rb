class CreateManifests < ActiveRecord::Migration
  def change
    create_table :manifests do |t|
      t.integer :user_id
      t.integer :region_id
      t.integer :level

      t.timestamps
    end
  end
end
