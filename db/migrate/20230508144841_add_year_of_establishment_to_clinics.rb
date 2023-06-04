class AddYearOfEstablishmentToClinics < ActiveRecord::Migration[7.0]
  def change
    add_column :clinics, :year_of_establishment, :integer
  end
end
