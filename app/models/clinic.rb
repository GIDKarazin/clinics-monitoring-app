class Clinic < ApplicationRecord
	has_many :departments, dependent: :destroy
	has_many :doctors, through: :departments
	has_many :patient_cards, dependent: :destroy
	has_many :patients, through: :patient_cards

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Incorrect email format!" }
	validates :phone, presence: true, length: { maximum: 20 }, format: { with: /\A\+?\d+\z/, message: "Incorrect phone format!" }
	validates :address, presence: true, length: { maximum: 100 }

	def update_name(new_name)
		self.name = new_name
		save
	end

	def update_email(new_email)
		self.email = new_email
		save
	end

	def update_phone(new_phone)
		self.phone = new_phone
		save
	end

	def update_address(new_address)
		self.address = new_address
		save
	end
end