class Doctor < ApplicationRecord
	belongs_to :department
	belongs_to :specialty
end
