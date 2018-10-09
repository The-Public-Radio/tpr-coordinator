class Invoice

  attr_reader :orders, :radio_total, :shipping_total

  # TODO: This method is a mess.
  def self.for_retailer(retailer)
    orders = []

    Order.uninvoiced.for_retailer(retailer).each do |o|
      # Only invoice orders where all shipments are in a 'boxed' state
      all_shipments_boxed = true

      o.shipments.each do |shipment|
        # if shipment status is not one of boxed, transit, or delivered, set all_boxed to false
        if !%w{boxed transit delivered}.include?(shipment.shipment_status)
          all_shipments_boxed = false
        end
      end

      orders << o if all_shipments_boxed
    end

    if !orders.any?
      Rails.logger.info("No orders found to invoice.")
      return nil
    else
      Rails.logger.info("Found #{orders.count} orders to invoice")

      return self.new(orders)
    end
  end

  private

  def initialize(orders)
    @orders = orders
    calculate_totals
  end

  def calculate_totals
    radio_total = 0
    shipping_total = 0

    orders.each do |order|
      order.shipments.each do |shipment|
        radio_total += shipment.cost_of_goods
        shipping_total += shipment.shipping_and_handling
      end
    end

    @radio_total = radio_total
    @shipping_total = shipping_total
  end
end
