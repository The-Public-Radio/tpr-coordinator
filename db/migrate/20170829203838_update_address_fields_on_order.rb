class UpdateAddressFieldsOnOrder < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :street_address_1, :string
  	add_column :orders, :street_address_2, :string
  	add_column :orders, :city, :string
  	add_column :orders, :state, :string
  	add_column :orders, :postal_code, :string
  	add_column :orders, :country, :string
  	add_column :orders, :phone, :string
  	remove_column :orders, :address
  end
end
