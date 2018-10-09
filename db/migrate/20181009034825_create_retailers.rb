class CreateRetailers < ActiveRecord::Migration[5.1]
  def change
    create_table :retailers do |t|
      t.string :name, null: false
      t.string :source, null: false
      t.integer :quickbooks_customer_id, null: false

      t.timestamps
    end
  end
end
