class User < ApplicationRecord
	has_many :posts
	validates  :email, uniqueness:true
	has_secure_password
end
