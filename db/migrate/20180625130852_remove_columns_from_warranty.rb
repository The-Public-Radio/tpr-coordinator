class RemoveColumnsFromWarranty < ActiveRecord::Migration[5.1]
  def change
    remove_column :shipments, :rate_reference_id
    remove_column :shipments, :shippo_reference_id
    remove_column :shipments, :return_label_url
  end
end