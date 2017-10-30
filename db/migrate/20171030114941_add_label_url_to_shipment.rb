class AddLabelUrlToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :label_url, :string
  end
end
