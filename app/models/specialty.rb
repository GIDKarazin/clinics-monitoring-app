class Specialty < ApplicationRecord
	has_many :doctors, dependent: :destroy

	validates :name, presence: true, length: { maximum: 50 }
	validates :description, presence: true, length: { maximum: 1000 }

	def update_name(new_name)
		query = <<-SQL
			UPDATE specialties SET name = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_name, id)
		statement.close
	end

	def update_description(new_description)
		query = <<-SQL
			UPDATE specialties SET description = ? WHERE id = ?
		SQL
		statement = ActiveRecord::Base.connection.raw_connection.prepare(query)
		statement.execute(new_description, id)
		statement.close
	end
end
