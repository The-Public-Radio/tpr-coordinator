require 'gmail'

namespace :orders do
  desc "Orders tasks"
  task send_uncommon_goods_shipments: :environment do
    include TaskHelper

    Rails.logger.info("Preparing and sending Uncommon Goods shipments")

    retailer = Retailer.for_source('uncommon_goods')

    orders = Order
      .for_retailer(retailer)
      .unnotified
      .with_shipments
      .find_all(&:all_radios_shipped?)

    if orders.empty? 
      Rails.logger.info("No orders shipped today. Not sending email to retailer.")
      next
    end

    Rails.logger.info("Creating CSV")

    today = Date.today.to_s
    file_name = "Centerline Labs LLC Shipments #{today}.csv"

    File.open(file_name, 'w') do |file|
      csv = ShipmentsCSV.new(orders)

      file.write(csv.generate)
    end

    # Send email
    recipient_emails = ENV['UNCOMMON_GOODS_INVOICING_EMAILS'].split(',')

    recipient_emails.each do |email_address|
      Rails.logger.info("Sending email to #{email_address}")
      email_params = {
        to: email_address,
        subject: "Centerline Labs LLC Shipments #{today}",
        add_file: file_name
      }

      TaskHelper.send_email(email_params)
    end

    orders.each do |order|
      order.update_attributes(notified: true)
    end
  end
end
