class CreateConfigTables < ActiveRecord::Migration
  def change
    create_table :config_tables do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
