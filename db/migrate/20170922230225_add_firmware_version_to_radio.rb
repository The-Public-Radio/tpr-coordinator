class AddFirmwareVersionToRadio < ActiveRecord::Migration[5.1]
  def change
    add_column :radios, :firmware_version, :string

    Radio.all.each do |radio|
      radio.firmware_version = 'a10fde1a52063d7022efb00924f25e9d915fc66c'
      radio.save!
    end
  end
end
