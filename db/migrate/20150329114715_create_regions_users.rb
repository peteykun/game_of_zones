class CreateRegionsUsers < ActiveRecord::Migration
  def change
    create_table :regions_users do |t|
      t.integer :region_id
      t.integer :user_id
    end
  end
end
