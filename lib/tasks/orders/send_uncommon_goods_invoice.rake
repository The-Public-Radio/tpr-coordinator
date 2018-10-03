require 'gmail'

namespace :orders do
  desc "Orders tasks"
  task send_uncommon_goods_invoice: :environment do
    include TaskHelper

    Rails.logger.info("Preparing and sending Uncommon Goods invoice")

    invoice = Invoice.for_source('uncommon_goods')

    Rails.logger.info("Creating CSV")

    today = Date.today.to_s
    invoice_file_name = "Centerline Labs LLC Invoice #{today}.csv"

    File.open(invoice_file_name, 'w') do |file|
      invoice_csv = InvoiceCSV.new(invoice.orders)

      file.write(invoice_csv.generate)
    end

    # Send email
    email_to_send_invoice_to = ENV['UNCOMMON_GOODS_INVOICING_EMAILS'].split(',')

    email_to_send_invoice_to.each do |email_address|
      Rails.logger.info("Sending invoice to #{email_address}")
      email_params = {
        to: email_address,
        subject: "Centerline Labs LLC Invoice #{today}",
        add_file: invoice_file_name
      }

      TaskHelper.send_email(email_params)
    end

    invoice.mark_orders_as_invoiced!
  end
end
