class AddEmailToOrder < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :email, :string
  end
end
