require 'csv'

namespace :orders do
  desc "Orders tasks"
  task import_orders_from_email: :environment do
    include TaskHelper

  	# load unread emails
  	emails = TaskHelper.find_unread_emails

    order_count = 0
  	# For each email, get the attachments and pase them into orders
  	Rails.logger.info("Processing #{emails.count} emails from order mailbox #{ENV['GMAIL_USERNAME']}")
  	emails.each_with_index do |email,i|
  		Rails.logger.info("Processing email #{i}")
		  email.message.attachments.each do |a|
  			Rails.logger.info("Reading attachments")
		    begin
		    	csv = CSV.parse(a.decoded)
		    rescue MalformedCSVError => e
		    	Rails.logger.error('Email attachment is not a CSV!')
		    	next
		    end

		    if csv[0].eql?(uncommon_goods_headers)
		    	# Process ucg order formated CSV
		    	parsed_csv = parse_ucg_csv(csv)
		    elsif csv[0].eql?(generic_csv_headers)
		    	# Process generic order formated CSV
		    	parsed_csv = parse_generic_csv(csv)
		    end
		    create_orders(parsed_csv)
        order_count += parsed_csv.count
		  end
		  email.read!
		end
    notify_of_import
  end

  def generic_csv_headers
    ["Name", "Email", "Address 1", "Address 2", "City", "State", "Postal Code", "Country", "Phone Number", "Shipment Priority", "Radio", "Radio", "Radio", "Radio", "Radio", "Radio", "Radio", "Radio", "Radio"]
  end

  def uncommon_goods_headers
     ["date_created", "expected_ship_date", "order_id", "quantity", "sku", "vendor_name", "item_name", "customer_name", "st_address_line1", "st_address_line2", "city", "state", "postal_code", "shipping_upgrade", "shipment_id", "external_order_id", "bill_first_name", "bill_last_name", "bill_address1", "bill_address2", "bill_city", "bill_zip", "bill_phonenum", "bill_company", "bill_code", "giftmessage", "Custom_Info"]
  end

  def parse_ucg_csv(csv)
    Rails.logger.info("Parsing uncommon_goods csv")
		orders = []
    map_order_csv(csv).each do |order|
      Rails.logger.debug("Mapping order: #{order}")

      begin
        frequency = order['Custom_Info'].split('/^')[1]
      rescue NoMethodError => e
        Rails.logger.error("Frequency field is missing or malformed: #{order['Custom_Info']}")
        raise e
      end
      frequency_list = []
      order['quantity'].to_i.times do
          frequency_list << frequency
      end

      order_params = {
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
        frequencies: frequency_list
      }
      orders << order_params
    end
    orders
  end

	def parse_generic_csv(csv)
    Rails.logger.info("Parsing generic csv")
		orders = []
		map_order_csv(csv).each do |order|
			order_params = {
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
        frequencies: [order['Radio'].compact]
			}
			orders << order_params
		end
		orders
	end

  def map_order_csv(csv)
    headers = csv.shift
    order_list = []

    csv.each do |order|
      hash = {}
      headers.each_with_index do |header,i|
        if header.include?('Radio')
          if hash[header].nil?
            hash[header] = []
          end
          hash[header] << order[i]
        else
          hash[header] = order[i]
        end
      end
      order_list << hash
    end
    order_list
  end

	def create_orders(orders)
    Rails.logger.info("Creating #{orders.count} orders")
		orders.each do |order_params|
      if order_params[:reference_number].nil?
        unless Order.find_by_name(order_params[:name]).nil?
          Rails.logger.info("Order already created for #{order_params[:name]}. Skipping.")
          next
        end
      else
        next unless Order.find_by_reference_number(order_params[:reference_number]).nil?
      end
      Rails.logger.info("Creating order with params:  #{order_params}.")
			OrdersController.new.make_queue_order_with_radios(order_params)
		end
	end

  def notify_of_import
    # TODO: Add in number of successful vs errors. Or maybe just errors complete success.
    emails = ENV['EMAILS_TO_NOTIFY_OF_IMPORT'].split(',')
    emails.each do |email|
      Rails.logger.info("Notifying #{email} of successful import.")
      email_params = {
        subject: "TPR Coordinator: UCG Import Complete #{Date.today}",
        to: email,
        body: "Uncommon Goods import complete!"
      }

      TaskHelper.send_email(email_params)
    end
  end

	def generic_from_email_whitelist
		ENV['GENERIC_ORDER_PROCESSING_FROM_EMAIL_WHITELIST']
	end
end
