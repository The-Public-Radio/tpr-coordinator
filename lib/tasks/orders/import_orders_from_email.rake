require 'csv'

class UnknownOrderSource < StandardError
end

namespace :orders do
  desc "Orders tasks"
  task import_orders_from_email: :environment do
    include TaskHelper

  	# load unread emails
  	emails = TaskHelper.find_unread_emails
    all_failed_orders = []
  	# For each email, get the attachments and pase them into orders
  	Rails.logger.info("Processing #{emails.count} emails from order mailbox #{ENV['GMAIL_USERNAME']}")

  	emails.each_with_index do |email,i|
      failed_orders = []
  		Rails.logger.info("Processing email #{i}")

		  email.message.attachments.each do |a|
  			Rails.logger.info("Reading attachments")
		    begin
		    	csv = CSV.parse(a.decoded)
		    rescue MalformedCSVError => e
		    	Rails.logger.error('Email attachment is not a CSV!')
		    	next
		    end

        # Set csv source and headers
        headers = csv.shift
        Rails.logger.debug("Checking headers for determine csv source: #{headers}")
        if headers.eql?(uncommon_goods_headers)
          @csv_source = 'uncommon_goods'
        elsif headers.eql?(generic_csv_headers)
          @csv_source = 'generic'
        end

        raise UnknownOrderSource if @csv_source.nil?

        # For each row in the csv, map to TPR params and create order while handling input errors
        csv.each do |row|
          # Map row into TPR order parameters
          order = map_order_row(headers, row)
          Rails.logger.debug("Mapped csv rows: #{order}")
          begin
            case @csv_source
            when 'uncommon_goods'
              order_params = parse_ucg_row(order)
            when 'generic'
              order_params = parse_generic_row(order)
            end
            Rails.logger.debug("Parsed order params: #{order_params}")
          rescue NoMethodError => e
            Rails.logger.info("Order field is missing or malformed: #{order['Custom_Info']}")
            Rails.logger.debug(e)

            row += ['Order field is missing or malformed. Check the requested frequency']
            failed_orders << row
            next
          end

          # Create order
          begin
            TaskHelper.create_order(order_params)
          rescue TaskHelper::TPROrderAlreadyCreated => e
            Rails.logger.warn("Order already imported!: #{order_params}")
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error("Validation error!: #{order_params}")
            TaskHelper.clean_up_order(order_params)
            row += ['Order inputs are malformed. Check frequency, name, and address fields']
            failed_orders << row
          rescue ShippoError => e
            Rails.logger.error("Shipping address is invalid!: #{order_params}")
            TaskHelper.clean_up_order(order_params)
            row += ['Shipping address failed USPS validation']
            failed_orders << row
          end
        end

        if failed_orders.any?
          Rails.logger.info("Processing #{failed_orders.count} failed orders")
          process_failed_orders(email, headers, failed_orders) if ENV['PROCESS_FAILED_ORDERS'] == 'true'
          all_failed_orders += failed_orders
        end
      end
      email.read!
		end

    if ENV['SEND_IMPORT_NOTIFICATION_EMAILS'] == true || emails.count != 0
      TaskHelper.notify_of_import(@csv_source, all_failed_orders)
    end
  end

  def generic_csv_headers
    ["Name", "Email", "Address 1", "Address 2", "City", "State", "Postal Code", "Country", "Phone Number", "Shipment Priority", "Radio"]
  end

  def uncommon_goods_headers
     ["date_created", "expected_ship_date", "order_id", "quantity", "sku", "vendor_name", "item_name", "customer_name", "st_address_line1", "st_address_line2", "city", "state", "postal_code", "shipping_upgrade", "shipment_id", "external_order_id", "bill_first_name", "bill_last_name", "bill_address1", "bill_address2", "bill_city", "bill_zip", "bill_phonenum", "bill_company", "bill_code", "giftmessage", "Custom_Info"]
  end

  def parse_ucg_row(order)
    Rails.logger.info("Parsing uncommon_goods csv")
    Rails.logger.debug("Parsing order: #{order}")

    # Handling quantity for field
    frequency = order['Custom_Info'].split('/^')[1]
    frequency_list = []
    order['quantity'].to_i.times do
        frequency_list << frequency
    end

    {
      name: order['customer_name'],
      order_source: "uncommon_goods",
      email: order['Email'],
      street_address_1: order['st_address_line1'],
      street_address_2: order['st_address_line2'],
      city: order['city'],
      state: order['state'],
      postal_code: order['postal_code'],
      country: 'US', # they only ship to US
      phone: order['bill_phonenum'],
      reference_number: "#{order['order_id']},#{order['shipment_id']}", # UCG order_id,shipment_id
      shipment_priority: shipment_priority_mapping(order['shipping_upgrade']),
      comments: order['giftmessage'],
      frequencies: {'US' => frequency_list }
    }
  end

	def parse_generic_row(order)
    Rails.logger.info("Parsing generic csv")
    Rails.logger.debug("Parsing order: #{order}")

		{
		  name: order['Name'],
		  order_source: 'other',
		  email: order['Email'],
		  street_address_1: order['Address 1'],
		  street_address_2: order['Address 2'],
		  city: order['City'],
		  state: order['State'],
		  postal_code: order['Postal Code'],
		  country: order['Country'],
		  phone: order['Phone Number'].nil? ? '' : order['Phone Number'],
      shipment_priority: order['Shipment Priority'],
      frequencies: { order['Country'] => order['Radio'].compact }
		}
	end

  def map_order_row(headers, row)
    hash = {}
    headers.each_with_index do |header,i|
      if header.include?('Radio')
        if hash[header].nil?
          hash[header] = []
        end
        hash[header] << row[i]
      else
        hash[header] = row[i]
      end
    end
    hash
  end

  def process_failed_orders(email, headers, failed_orders)
    # TODO: Don't use file system
    CSV.open('failed_orders.csv', 'w') do |csv|
      # Use same headers as the original order csv + an errors column
      headers += ['Errors']
      csv << headers
      failed_orders.each do |order|
        csv << order
      end
    end

    from_address = "#{email.sender[0].mailbox}@#{email.sender[0].host}"
    unless ENV['EMAILS_TO_SEND_FAILED_ORDERS'].nil?
      from_address = "#{from_address},#{ENV['EMAILS_TO_SEND_FAILED_ORDERS']}"
    end

    # Send initial reply
    Rails.logger.info("Replying to #{from_address} with failed orders CSV")
    TaskHelper.send_reply(email, {
      to: from_address,
      body: "Please see attached csv for #{failed_orders.count} orders with errors",
      add_file: 'failed_orders.csv' })
  end
end
