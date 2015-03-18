class ConfigTable < ActiveRecord::Base
  def self.lookup(key)
    tuple = ConfigTable.find_by_key(key)

    return nil if tuple == nil
    return tuple.value
  end

  def self.set(key, value)
    tuple = ConfigTable.find_by_key(key)

    return false if tuple == nil
    
    tuple.value = value
    return tuple.save
  end
end
