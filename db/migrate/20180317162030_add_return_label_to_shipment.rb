class AddReturnLabelToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :return_label_url, :string
  end
end
