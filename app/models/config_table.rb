class ConfigTable < ActiveRecord::Base
  def self.lookup(key)
    tuple = ConfigTable.find_by_key(key)

    return nil if tuple == nil
    return tuple.value
  end
end
