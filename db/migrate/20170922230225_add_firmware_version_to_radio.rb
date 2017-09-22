class AddFirmwareVersionToRadio < ActiveRecord::Migration[5.1]
  def change
    add_column :radios, :firmware_version, :string

    Radio.all.each do |radio|
      radio.firmware_version = '1'
      radio.save!
    end
  end
end
