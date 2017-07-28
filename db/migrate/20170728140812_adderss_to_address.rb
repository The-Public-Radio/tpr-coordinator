class AdderssToAddress < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :adderss, :address

  end
end
