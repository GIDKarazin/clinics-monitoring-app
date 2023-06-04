class AddDoctorIdToPatientCards < ActiveRecord::Migration[7.0]
  def change
    add_reference :patient_cards, :doctor, foreign_key: true
  end
end