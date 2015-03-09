## Based on:
## http://stackoverflow.com/a/7758109/1825792

class AdminConfig
  # uncomment this if in development
  #unloadable

  # I assume you have the fields key/value in your 
  # ConfigTable you may need to change this

  def self.all
    # create a cached hash
    @cache ||= ConfigTable.all.inject({}) do |hsh, c_config|
      hsh[c_config.key.to_sym] = c_config.value
      hsh
    end
  end 

  def self.get(key)
    self.all[key.to_sym]
  end

  def self.[](key)
    self.all[key.to_sym]
  end
end
