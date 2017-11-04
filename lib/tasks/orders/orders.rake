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
		    	csv = CSV.read(a)
		    rescue Exception => e
		    	Rails.logger.error('Email attachment is not a CSV!')
		    	next
		    end

		    case email.from[0].host
		    when 'ucg.com'
		    	# Process ucg order formated CSV
		    	parsed_csv = parse_ucg_csv(csv)
		    when generic_from_email_whitelist.include?('spencer@gmail.com' || 'zach@gmail.com')
		    	# Process generic order formated CSV
		    	parsed_csv = parse_generic_csv(csv)
		    end
		    create_orders(parsed_csv)
		  end
		  email.read
		end
  end

  def parse_ucg_csv(csv)
		# Headers are ?

  end

	def parse_generic_csv(csv)
		# Headers are Name, Email, Address 1, Address 2, City, State, Postal Code, Country, Phone Number, Radio, Radio, Radio

		orders = []
		csv.each do |order|
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
			  phone: order['Phone Number'].nil? ? '' : order['Phone Number']
			}

			frequencies = []

			order.select{ |s| s.include?('Radio') }.each do |k,v|
				frequencies << v
			end

			order_params['frequencies'] = { order['Shipping Country Code']  => frequencies.compact }

			orders << order_params
		end
		orders
	end

	def create_orders(orders)
		orders.each do |order|
			OrderController.new.create(order)
		end
	end

	def generic_from_email_whitelist
		ENV['GENERIC_ORDER_PROCESSING_FROM_EMAIL_WHITELIST']
	end

  def login_to_gmail
  	Gmail.connect!(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])
  end

  def order_processing_email
  	ENV['ORDER_PROCESSING_EMAIL']
  end
end
