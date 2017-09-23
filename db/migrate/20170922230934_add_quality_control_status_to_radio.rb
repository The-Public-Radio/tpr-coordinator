class AddQualityControlStatusToRadio < ActiveRecord::Migration[5.1]
  def change
    add_column :radios, :quality_control_status, :string

    # Radio.all.each do |radio|
    #   next unless !radio.shipment_id.nil? && radio.boxed?
    #   radio.quality_control_status = 'passed'
    #   radio.save!
    # end
  end
end
