require 'gmail'

namespace :orders do
  desc "Orders tasks"
  task import_orders_from_email: :environment do
  	gmail_client = login_to_gmail

  	# load unread emails from ucg
  	emails = gmail_client.inbox.find(:unread)

  	# For each email, get the attachments and pase them into orders
  	Rails.logger.info("Processing #{emails.count} emails from order mailbox #{ENV['GMAIL_USERNAME']}")
  	emails.each_with_index do |email,i|
  		Rails.logger.info("Processing email #{i}")
		  email.message.attachments.each do |a|
  			Rails.logger.info("Reading attachments")
		    begin
		    	csv = CSV.parse(a.decode)
		    rescue MalformedCSVError => e
		    	Rails.logger.error('Email attachment is not a CSV!')
		    	next
		    end

		    host = email.from[0].host
		    if host == 'ucg.com'
		    	# Process ucg order formated CSV
		    	parsed_csv = parse_ucg_csv(csv)
		    elsif generic_from_email_whitelist.include?(host)
		    	# Process generic order formated CSV
		    	parsed_csv = parse_generic_csv(csv)
		    end
		    create_orders(parsed_csv)
		  end
		  email.read
		end
  end

  def parse_ucg_csv(csv)
    # TODO: Check this format with an UCG order csv
		orders = []
    map_order_csv(csv).each do |order|
      order_params = {
        name: order['Name'],
        order_source: 'UCG',
        email: order['Email'],
        street_address_1: order['Address 1'],
        street_address_2: order['Address 2'],
        city: order['City'],
        state: order['State'],
        postal_code: order['Postal Code'],
        country: order['Country'],
        phone: order['Phone Number'].nil? ? '' : order['Phone Number'],
        frequencies: order['Radio'].compact
      }
      orders << order_params
    end
    orders
  end

	def parse_generic_csv(csv)
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
        frequencies: order['Radio'].compact
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
		orders.each do |order_params|
			OrdersController.new.make_queue_order_with_radios(order_params)
		end
	end

	def generic_from_email_whitelist
		ENV['GENERIC_ORDER_PROCESSING_FROM_EMAIL_WHITELIST']
	end

  def login_to_gmail
  	Gmail.connect!(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
  end
end
