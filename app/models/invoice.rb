class Invoice

  attr_reader :orders

  # TODO: The query here should be something on `Order` or a specialized query object
  def self.for_source(source)
    orders = []

    # TODO: Pull orders that are order_source: 'uncommon_goods' and invoiced: false in the same query
    Order.where(order_source: source).each do |o|
      # Skip invoiced orders
      next if o.invoiced

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
      Rails.logger.info("No orders found to invoice. Exiting.")
    else
      Rails.logger.info("Found #{orders.count} orders to invoice")
    end

    self.new(orders)
  end

  def mark_orders_as_invoiced!
    orders.each do |order|
      order.update_attributes(invoiced: true)
    end
  end

  private

  def initialize(orders)
    @orders = orders
  end
end
