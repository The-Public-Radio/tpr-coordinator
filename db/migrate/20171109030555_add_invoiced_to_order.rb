class AddInvoicedToOrder < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :invoiced, :boolean
  end
end
