class Invoice

  attr_reader :retailer, :orders, :radio_count, :radio_total, :shipping_total

  def self.for_retailer(retailer)
    orders = Order
      .for_retailer(retailer)
      .uninvoiced
      .with_shipments
      .find_all(&:all_radios_shipped?)

    if !orders.any?
      Rails.logger.info("No orders found to invoice.")
      return nil
    else
      Rails.logger.info("Found #{orders.count} orders to invoice")

      return self.new(retailer, orders)
    end
  end

  def mark_orders_as_invoiced!
    ActiveRecord::Base.transaction do
      orders.each do |order|
        order.update_attributes(invoiced: true)
      end
    end
  end

  def to_csv
    ShipmentsCSV.new(self.orders).generate
  end

  private

  def initialize(retailer, orders)
    @retailer = retailer
    @orders = orders
    calculate_totals
  end

  def calculate_totals
    radio_count = 0
    radio_total = 0
    shipping_total = 0

    orders.each do |order|
      order.shipments.each do |shipment|
        radio_count += shipment.radio_count
        radio_total += shipment.cost_of_goods
        shipping_total += shipment.shipping_and_handling
      end
    end

    @radio_count = radio_count
    @radio_total = radio_total
    @shipping_total = shipping_total
  end
end
