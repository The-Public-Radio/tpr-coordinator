class AddBoxedColumnToRadio < ActiveRecord::Migration[5.1]
  def change
  	add_column :radios, :boxed, :boolean
  end
end
