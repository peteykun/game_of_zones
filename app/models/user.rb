class User < ActiveRecord::Base
	validates_presence_of    :email
	validates_uniqueness_of  :email
	has_many                 :runs
	has_many                 :regions

	has_secure_password

	def is_admin?
		return self.is_admin
	end
end
