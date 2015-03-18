class AddGameManagerRowsToConfigTable < ActiveRecord::Migration
  def self.up
    execute "insert into config_tables (key, value) values ('zone_scheduler_enabled', 'false')"
    execute "insert into config_tables (key, value) values ('scoring_scheduler_enabled', 'false')"
  end

  def self.down
  end
end
