class AddSettingsRowsToConfigTable < ActiveRecord::Migration
  def self.up
    execute "insert into config_tables (key, value) values ('test_case_limit', 5)"
    execute "insert into config_tables (key, value) values ('submission_time_limit', 120)"
  end

  def self.down
  end
end
