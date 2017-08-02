class AddOrderIdToShipment < ActiveRecord::Migration[5.1]
  def change
  	add_column :shipments, :order_id, :integer
  end
end
