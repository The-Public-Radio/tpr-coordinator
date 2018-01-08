class MakeNotifyABoolean < ActiveRecord::Migration[5.1]
  def change
  	change_column :orders, :notified, 'boolean USING CAST(notified AS boolean)'
  end
end
