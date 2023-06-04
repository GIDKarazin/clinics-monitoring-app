class AddOptionalFieldsToPatientCardModel < ActiveRecord::Migration[7.0]
  def change
    add_column :patient_cards, :description, :text
  end
end
