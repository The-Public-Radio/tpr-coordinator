require 'gmail'

namespace :orders do
  desc "Orders tasks"
  task send_uncommon_goods_invoice: :environment do
  	gmail_client = login_to_gmail

    email_to_send_invoice_to = ENV['UNCOMMON_GOODS_INVOICING_EMAILS']
    today = Date.today.to_s
    invoice_file_name = "tpr_invoice_#{today.gsub('-','_')}.csv"

  # TODO: Find a way to not write this to the file system
    CSV.open(invoice_file_name, "w") do |csv|
        # Add headers to invoice csv
        csv << ['order_id', 'usps_tracking_number', 'cost_of_goods']
        # Add each shipment to order
        orders_to_invoice.each do |order|
            order.shipments.each do |shipment|
                csv << [order.reference_number, shipment.tracking_number, 33.75 * shipment.radio.count]
            end
        end
    end

    # Send email
    email_to_send_invoice_to.each do |email_address|
      gmail_client.deliver do 
        to email_address
        subject "The Public Radio Invoice #{today}"
        add_file invoice_file_name
      end
    end
  end

  def orders_to_invoice
    orders_to_invoice = []
    Order.where(order_source: 'uncommon_goods').each do |o|
      next if o.invoiced
      next unless o.shipments.select{ |s| %w{boxed transit delivered}.include?(s.shipment_status) }.any?
      orders_to_invoice << o
    end

    if !orders_to_invoice.any?
      Rails.logger.info("No orders found to invoice. Exiting.")
      exit
    else
      orders_to_invoice
    end
  end

  def login_to_gmail
  	Gmail.connect!(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
  end
end
