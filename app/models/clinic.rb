class Clinic < ApplicationRecord
	has_many :departments, dependent: :destroy
	has_many :doctors, through: :departments
	has_many :patient_cards, dependent: :destroy
	has_many :patients, through: :patient_cards

	validates :name, presence: true, length: { maximum: 100 }
	validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Incorrect email format!" }
	validates :phone, presence: true, length: { maximum: 20 }, format: { with: /\A\+?\d+\z/, message: "Incorrect phone format!" }
	validates :address, presence: true, length: { maximum: 100 }
    validates :year_of_establishment, presence: true, length: { maximum: 10 }, format: { with: /\A(16[0-9]{2}|17[0-9]{2}|18[0-9]{2}|19[0-9]{2}|20[0-1][0-9]|202[0-3])\z/, message: "Incorrect year of establishment format!" }
	validates :facility_type, presence: true, length: { maximum: 100 }
	validates :city, presence: true, length: { maximum: 100 }
	validates :rating_mortality, presence: true, length: { maximum: 100 }
	
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

	def update_year_of_establishment(new_year_of_establishment)
		self.year_of_establishment = new_year_of_establishment
		save
	end

	def update_facility_type(new_facility_type)
		self.facility_type = new_facility_type
		save
	end

	def update_city(new_city)
		self.city = new_city
		save
	end

	def update_rating_mortality(new_rating_mortality)
		self.rating_mortality = new_rating_mortality
		save
	end
end