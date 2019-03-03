require 'squarespace'

namespace :orders do
  desc "Import squarespace orders"
  task import_orders_from_squarespace: :environment do
    include TaskHelper
  	Rails.logger.info('Starting Squarespace import')
  	client = Squarespace::Client.new(
      app_name: ENV['SQUARESPACE_APP_NAME'], 
      api_key: ENV['SQUARESPACE_API_KEY']
      )

  	orders = client.get_pending_orders()
  	Rails.logger.info("Importing #{orders[:result].count} orders")

    failed_orders = []

  	orders[:result].each do |order|
  	  shipping_address = order['shippingAddress']
      frequency_list = []
      radio_country_code = ''

      Rails.logger.debug("Parsing order #{order}")
      order['lineItems'][0]['customizations'].each do |c|
        case c['label']
        when 'Tuning frequency'
            frequency = c['value']
        when 'Where will you be using your radio?'
            radio_country_code = c['value'][0..1]
        end

		    order['lineItems'][0]['quantity'].times do
		        frequency_list << frequency
		    end
      end

      order_params = {
          name: "#{shipping_address['firstName']} #{shipping_address['lastName']}",
          order_source: "squarespace",
          email: order['customerEmail'],
          street_address_1: shipping_address['address1'],
          street_address_2: shipping_address['address2'],
          city: shipping_address['city'],
          state: shipping_address['state'],
          postal_code: shipping_address['postalCode'],
          country: shipping_address['countryCode'],
          phone: shipping_address['phone'],
          reference_number: "#{order['id']},#{order['orderNumber']}", # Squarespace order number
          shipment_priority: 'economy',
          frequencies: { radio_country_code => frequency_list.compact }
      }
      Rails.logger.debug("Creating order with params: #{order_params}")

      begin
        TaskHelper.create_order(order_params)
      rescue TaskHelper::TPROrderAlreadyCreated => e
        Rails.logger.warn("Order already imported!: #{order_params}")
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Validation error!: #{order_params}")
        TaskHelper.clean_up_order(order_params)
        failure_info = {
          customer_email: order.email,
          reason: "Validation error: Order inputs are malformed. Check frequency, name, and address fields. #{e.message}"
        }
        failed_orders << failure_info
      rescue ShippoHelper::ShippoError => e
        Rails.logger.error("Shipping address is invalid!: #{order_params}")
        TaskHelper.clean_up_order(order_params)
        failure_info = {
          customer_email: order.email,
          reason: "Shipping address is invalid: #{e.message}"
        }
        failed_orders << failure_info
      end
    end
    
    if failed_orders.any? || ENV['SEND_IMPORT_NOTIFICATION_EMAILS_SQUARESPACE'] == true
      TaskHelper.notify_of_import('squarespace', failed_orders)
    end
  end
end