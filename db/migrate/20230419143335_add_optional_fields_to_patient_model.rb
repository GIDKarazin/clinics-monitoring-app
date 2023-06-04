class AddOptionalFieldsToPatientModel < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :email, :string
    add_column :patients, :phone, :string
    add_column :patients, :address, :string
  end
end
