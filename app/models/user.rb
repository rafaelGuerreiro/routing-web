class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :lockable, :rememberable, :trackable, :validatable
end
