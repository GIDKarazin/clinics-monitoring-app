class AddOptionalFieldsToClinicModel < ActiveRecord::Migration[7.0]
  def change
    add_column :clinics, :email, :string
    add_column :clinics, :phone, :string
  end
end
