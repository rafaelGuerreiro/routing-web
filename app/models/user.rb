class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :lockable, :rememberable, :trackable, :validatable

  before_validation :downcase_email
  before_save :downcase_email

  validates :email, :encrypted_password, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  def google_maps_key
    'this will be the google maps key'
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
