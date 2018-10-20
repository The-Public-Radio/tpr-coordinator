class ShipmentsCSV
  HEADERS = [
    'order_id',
    'shipment_id',
    'usps_tracking_number',
    'quantity',
    'cost_of_goods',
    'shipping_handling_costs',
  ].freeze

  attr_reader :orders

  def initialize(orders)
    @orders = orders
  end

  def generate
    CSV.generate do |csv|
      csv << HEADERS

      @orders.each do |order|
        order.shipments.each do |shipment|
          ucg_order_id, ucg_shipment_id = order.reference_number.split(',')

          csv << [
            ucg_order_id,
            ucg_shipment_id,
            shipment.tracking_number,
            shipment.radio_count,
            shipment.cost_of_goods,
            shipment.shipping_and_handling,
          ]
        end
      end
    end
  end
end
