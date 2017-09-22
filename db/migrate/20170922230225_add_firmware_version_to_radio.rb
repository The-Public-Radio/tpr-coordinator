class AddFirmwareVersionToRadio < ActiveRecord::Migration[5.1]
  def change
    add_column :radios, :firmware_version, :string
  end
end
