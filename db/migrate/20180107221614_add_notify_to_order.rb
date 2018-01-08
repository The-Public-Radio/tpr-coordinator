class AddNotifyToOrder < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :notified, :string
  end
end
