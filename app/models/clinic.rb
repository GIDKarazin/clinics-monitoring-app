class Clinic < ApplicationRecord
	has_many :departments
	has_many :doctors, through: :departments
	has_many :patient_cards
	has_many :patients, through: :patient_cards
end
