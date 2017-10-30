class AddPriorityToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :priority_processing, :boolean
  end
end
