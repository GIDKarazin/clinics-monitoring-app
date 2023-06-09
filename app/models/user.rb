class User < ApplicationRecord
  has_one_attached :avatar
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  validates :email, presence: true, uniqueness: true

  def update_email(new_email)
    self.email = new_email
    save
  end
end