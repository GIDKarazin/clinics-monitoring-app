class Patient < ApplicationRecord
	has_one :patient_card, dependent: :destroy

	validates :name, presence: true, length: { maximum: 50 }
	validates :birthdate, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/, message: "Incorrect date format! Example: 'YYYY-MM-DD'" }
	validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Incorrect email format!" }
	validates :phone, presence: true, length: { maximum: 20 }, format: { with: /\A\+?\d+\z/, message: "Incorrect phone format!" }
	validates :address, presence: true, length: { maximum: 100 }

	def update_name(new_name)
		self.name = new_name
		save
	end

	def update_birthdate(new_birthdate)
		self.birthdate = new_birthdate
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
