class AddShippoReferenceToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :shippo_reference_id, :string
  end
end
