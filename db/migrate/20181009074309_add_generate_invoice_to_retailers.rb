class AddGenerateInvoiceToRetailers < ActiveRecord::Migration[5.1]
  def change
    add_column :retailers, :generate_invoice, :boolean, default: false
  end
end
