class CreateShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :shipments do |t|
      t.string :tracking_number
      t.string :ship_date
      t.string :status

      t.timestamps
    end
  end
end
