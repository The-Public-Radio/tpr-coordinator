require 'squarespace'

namespace :orders do
  desc "Mark squarespace orders as fulfilled"
  task fulfill_squarespace_orders: :environment do
    Rails.logger.info("Marking squarespace orders as fulfilled")

  	client = Squarespace::Client.new(app_name: ENV['SQUARESPACE_APP_NAME'], api_key: ENV['SQUARESPACE_API_KEY'])

  	orders_to_fulfill = Order.where(order_source: 'squarespace').where.not(notified: true)

  	orders_to_fulfill.select do |o| 
      o.shipments.each do |s| 
        %w{created label_created label_printed}.exclude?(s.shipment_status)
      end
    end

    Rails.logger.info("Found #{orders_to_fulfill.count} orders to fulfill")

  	orders_to_fulfill.each do |order|
  		Rails.logger.debug("Fulfilling order: #{order}")

  		id, order_number = order[:reference_number].split(',')

  		shipments = []
  		order.shipments.each do |shipment|
	     shipments << {
	        tracking_number: shipment[:tracking_number],
	        tracking_url: "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=#{shipment['tracking_number']}",
	        carrier_name: 'USPS',
	        service: shipment[:shipment_priority]
	      }
  		end

  		Rails.logger.debug("Fulfill params: #{id}, #{shipments}")
      case ENV['SEND_SQUARESPACE_NOTIFICATION_EMAILS']
      when false
        send_notification = false
      else
        send_notification = true
      end
            
  		response = client.fulfill_order(id, shipments, send_notification)
  		if response.success?
  			Rails.logger.debug("Fulfill order succeded. Marking as notified/")
  			order.notified = true
  			order.save!
  		else
  			Rails.logger.error("Fulfill order failed: #{response.status}")
  		end
  	end
  end
end
