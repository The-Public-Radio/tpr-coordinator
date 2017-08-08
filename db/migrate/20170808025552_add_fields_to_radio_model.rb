class AddFieldsToRadioModel < ActiveRecord::Migration[5.1]
  def change
  	add_column :radios, :pcb_version, :string
  	add_column :radios, :serial_number, :string
  	add_column :radios, :assembly_date, :string
  	add_column :radios, :operator, :string
  end
end
