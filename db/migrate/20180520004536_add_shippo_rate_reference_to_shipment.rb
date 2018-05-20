class AddShippoRateReferenceToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :rate_reference_id, :string
  end
end
