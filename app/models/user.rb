class User < ActiveRecord::Base
	validates_presence_of    :email, :username, :name, :college, :gender, :phone
  validates                :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates                :username, length: { maximum: 8 }
  validates                :gender, inclusion: { in: ['male', 'female'] }
  validates                :is_admin, inclusion: { in: [true, false] }

	validates_uniqueness_of   :email, :username
  validates_numericality_of :phone
	has_many                  :runs
	has_and_belongs_to_many   :regions
  has_many                  :manifests

	has_secure_password
  attr_accessor :level

	def is_admin?
		return self.is_admin
	end

  def level(region)
    m = Manifest.where(user: self, region: region)

    return 0 if m == nil or m.size == 0
    return m[0].level
  end
end
