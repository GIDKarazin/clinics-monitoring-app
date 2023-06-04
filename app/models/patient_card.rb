class PatientCard < ApplicationRecord
	belongs_to :clinic
	belongs_to :patient

	validates :code, presence: true, length: { maximum: 10 }, format: { with: /\A[A-Z]{2}\d{4}\z/, message: "Incorrect code format! Example: 'AZ9630'" }
	validates :description, presence: true, length: { maximum: 1000 }

	def update_name(new_code)
		query = <<-SQL
			UPDATE patientcards SET code = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_code, id)
		statement.close
	end

	def update_description(new_description)
		query = <<-SQL
			UPDATE patientcards SET description = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_description, id)
		statement.close
	end
end
