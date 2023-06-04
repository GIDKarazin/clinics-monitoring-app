class Department < ApplicationRecord
	belongs_to :clinic
	has_many :doctors
end
