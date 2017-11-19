class RemoveLabelDataFromShipment < ActiveRecord::Migration[5.1]
  def change
  	remove_column :shipments, :label_data
  end
end
