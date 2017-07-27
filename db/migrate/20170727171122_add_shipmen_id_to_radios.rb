class AddShipmenIdToRadios < ActiveRecord::Migration[5.1]
  def change
    add_column :radios, :shipment_id, :integer  end
end
