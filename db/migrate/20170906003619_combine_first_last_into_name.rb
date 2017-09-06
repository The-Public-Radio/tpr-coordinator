class CombineFirstLastIntoName < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :name, :string

  	Order.all.each do |order|
  		order.name = "#{order.first_name} #{order.last_name}}"
  	end

  	remove_column :orders, :first_name, :string
  	remove_column :orders, :last_name, :string
  end
end
