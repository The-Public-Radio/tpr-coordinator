require 'gmail'
# require 'app/helpers/task_helper'

namespace :orders do
  desc "Orders tasks"
  task send_uncommon_goods_invoice: :environment do
    include TaskHelper

    Rails.logger.info("Preparing and sending Uncommon Goods invoice")

    email_to_send_invoice_to = ENV['UNCOMMON_GOODS_INVOICING_EMAILS'].split(',')
    today = Date.today.to_s
    invoice_file_name = "Centerline Labs LLC Invoice #{today}.csv"

    # load orders
    orders = orders_to_invoice

    # TODO: Find a way to not write this to the file system
    Rails.logger.info("Creating CSV")
    CSV.open(invoice_file_name, "w") do |csv|
      # Add headers to invoice csv
      csv << ['order_id', 'shipment_id', 'usps_tracking_number', 'quantity','cost_of_goods', 'shipping_handling_costs']
      # Add each shipment to order
      orders.each do |order|
        order.shipments.each do |shipment|
          ucg_order_id, ucg_shipment_id = order.reference_number.split(',')
          num_radios = shipment.radio.count
          shipping_and_handling = TaskHelper.calculate_shipping_and_handling(num_radios, shipment.shipment_priority)
          csv << [ucg_order_id, ucg_shipment_id, shipment.tracking_number, num_radios,  Radio::PRICE * num_radios, shipping_and_handling]
        end
      end
    end

    # Send email
    email_to_send_invoice_to.each do |email_address|
      Rails.logger.info("Sending invoice to #{email_address}")
      email_params = {
        to: email_address,
        subject: "Centerline Labs LLC Invoice #{today}",
        add_file: invoice_file_name
      }

      TaskHelper.send_email(email_params)
    end

    # mark orders as invoiced
    orders.each do |order|
      order.invoiced = true
      order.save
    end
  end

  def orders_to_invoice
    orders = []
    # TODO: Pull orders that are order_source: 'uncommon_goods' and invoiced: false in the same query
    Order.where(order_source: 'uncommon_goods').each do |o|
      # Skip invoiced orders
      next if o.invoiced
      # Only invoice orders where all shipments are in a 'boxed' state
      shipments = o.shipments
      all_shipments_boxed = true
      shipments.each do |shipment|
        # if shipment status is not one of boxed, transit, or delivered, set all_boxed to false
        if !%w{boxed transit delivered}.include?(shipment.shipment_status)
          all_shipments_boxed = false
        end
      end
      orders << o if all_shipments_boxed
    end

    if !orders.any?
      Rails.logger.info("No orders found to invoice. Exiting.")
      exit
    else
      Rails.logger.info("Found #{orders.count} orders to invoice")
      orders
    end
  end
end
