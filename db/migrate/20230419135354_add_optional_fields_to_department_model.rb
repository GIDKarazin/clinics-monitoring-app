class AddOptionalFieldsToDepartmentModel < ActiveRecord::Migration[7.0]
  def change
    add_column :departments, :description, :text
  end
end
