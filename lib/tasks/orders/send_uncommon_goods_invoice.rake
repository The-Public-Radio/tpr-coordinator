require 'gmail'

namespace :orders do
  desc "Orders tasks"
  task send_uncommon_goods_invoice: :environment do
    Rails.logger.info("Preparing and sending Uncommon Goods invoice")

  	gmail_client = login_to_gmail

    email_to_send_invoice_to = ENV['UNCOMMON_GOODS_INVOICING_EMAILS'].split(',')
    today = Date.today.to_s
    invoice_file_name = "Centerline Labs LLC Invoice #{today}.csv"

    # load orders
    orders = orders_to_invoice

    # TODO: Find a way to not write this to the file system
    Rails.logger.info("Creating CSV")
    CSV.open(invoice_file_name, "w") do |csv|
      # Add headers to invoice csv
      csv << ['order_id', 'shipment_id', 'usps_tracking_number', 'cost_of_goods', 'shipping_handling_costs']
      # Add each shipment to order
      orders.each do |order|
        order.shipments.each do |shipment|
          ucg_order_id, ucg_shipment_id = order.reference_number.split(',')
          csv << [ucg_order_id, ucg_shipment_id, shipment.tracking_number, 33.75 * shipment.radio.count, 5 * shipment.radio.count]
        end
      end
    end

    # Send email
    email_to_send_invoice_to.each do |email_address|
      Rails.logger.info("Sending invoice to #{email_address}")
      gmail_client.deliver do 
        from ENV['INVOICE_FROM_EMAIL_ADDRESS']
        to email_address
        subject "Centerline Labs LLC Invoice #{today}"
        add_file invoice_file_name
      end
    end

    # mark orders as invoiced
    orders.each do |order|
      order.invoiced = true
      order.save
    end
  end

  def orders_to_invoice
    orders = []
    Order.where(order_source: 'uncommon_goods').each do |o|
      next if o.invoiced
      next unless o.shipments.select{ |s| %w{boxed transit delivered}.include?(s.shipment_status) }.any?
      orders << o
    end

    if !orders.any?
      Rails.logger.info("No orders found to invoice. Exiting.")
      exit
    else
      Rails.logger.info("Found #{orders.count} orders to invoice")
      orders
    end
  end

  def login_to_gmail
  	Gmail.connect!(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
  end
end