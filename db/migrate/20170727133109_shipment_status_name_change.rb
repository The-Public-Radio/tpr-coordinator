class ShipmentStatusNameChange < ActiveRecord::Migration[5.1]
  def change
    rename_column :shipments, :status, :shipment_status
  end
end
