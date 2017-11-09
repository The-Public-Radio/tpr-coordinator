class AddReferenceNumberToOrder < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :reference_number, :string
  end
end
