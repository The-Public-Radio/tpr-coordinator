class AddLabelDataToShipment < ActiveRecord::Migration[5.1]
  def change
  	add_column :shipments, :label_data, :string
  end
end
