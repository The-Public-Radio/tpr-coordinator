class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :adderss
      t.string :order_source

      t.timestamps
    end
  end
end
