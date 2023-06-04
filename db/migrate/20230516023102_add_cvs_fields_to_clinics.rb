class AddCvsFieldsToClinics < ActiveRecord::Migration[7.0]
  def change
    add_column :clinics, :facility_type, :string
    add_column :clinics, :city, :string
    add_column :clinics, :rating_mortality, :string
  end
end
