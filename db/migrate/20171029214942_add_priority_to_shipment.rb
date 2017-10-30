class AddPriorityToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :priority, :boolean
  end
end
