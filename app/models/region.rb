class Region < ActiveRecord::Base
  validates_presence_of  :name
	belongs_to             :user
	has_many               :problems
  has_many               :manifests
  has_many               :users, through: :manifests

  def level(user)
    m = Manifest.where(user: user, region: self)

    return 0 if m == nil or m.size == 0
    return m[0].level
  end
end
