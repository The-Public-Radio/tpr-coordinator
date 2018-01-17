namespace :radios do
  desc "Send a daily count of the number of radios that have been made tasks"
  task send_radios_created_today_email: :environment do
    include TaskHelper

    # Get all radios that were created today and have a frequency (only radios attached to orders)
    radios = Radio.where("created_at >= ? AND frequency IS NOT ?", (Time.now - 24.hours), nil)

    order_hash = {}
    radios.each do |radio|
      order_source = radio.shipment.order.order_source

      if order_hash[order_source].nil?
        order_hash[order_source] = 1
      else
        order_hash[order_source] += 1
      end
    end

    body_arr = ['Radios created today:']
    order_hash.each do |order_source, radio_count|
      body_arr << "#{order_source}: #{radio_count}"
    end

    body = body_arr.join("\n\t")

    emails = ENV['EMAILS_TO_NOTIFY_OF_IMPORT'].split(',')
    emails.each do |email|
      Rails.logger.info("Notifying #{email} of radios ordered today")

      email_params = {
        to: email,
	      subject: "TPR Coordinator: #{radios.count} radios were ordered today",
	      body: body
      }
    
      TaskHelper.send_email(email_params) 
    end
  end
end