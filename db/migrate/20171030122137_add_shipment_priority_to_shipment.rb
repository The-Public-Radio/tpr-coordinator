class AddShipmentPriorityToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :shipment_priority, :string
  end
end
