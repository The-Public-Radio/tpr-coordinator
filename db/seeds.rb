# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.production?
  raise 'DO NOT DO THIS IN PRODUCTION'
end

def random_tpr_serial_number
  "TPRv2.0_1_#{Random.new.rand(99999)}"
end

def random_frequency
  Random.new.rand(78.0..108.0).round(1)
end

def random_tracking_number
  number = "9374889691090496#{Random.new.rand(99999)}"
  chars = number.gsub(/^420\d{5}/, '').chars.to_a

  total = 0
  chars.reverse.each_with_index do |c, i|
    x = c.to_i
    x *= 3 if i.even?
    total += x
  end

  check_digit = total % 10
  check_digit = 10 - check_digit unless (check_digit.zero?)
  # TrackingNumber.new("#{number}#{check_digit}")
  "#{number}#{check_digit}"
end

def random_name
  Faker::Name.name
end

orders_params = [
	# 1-line economy order
	{
	    name: 'Sally Person',
		order_source: 'uncommon_goods',
		street_address_1: "544 Park Ave",
	    street_address_2: 'Ste 332',
	    city: 'Brooklyn',
	    state: 'NY',
	    postal_code: '11205',
	    country: 'US',
	    phone: '123-321-1231',
		email: 'Person.McPersonson@gmail.com'
	},
	# 2-line economy order
	{
	    name: 'John Person',
	    order_source: 'uncommon_goods',
	    street_address_1: "544 Park Ave",
	    street_address_2: 'Ste 332',
	    city: 'Brooklyn',
	    state: 'NY',
	    postal_code: '11205',
	    country: 'US',
	    phone: '123-321-1231',
	    email: 'Person.McPersonson@gmail.com'
	},
	# 3-line economy order
	{
	    name: 'Jamie Person',
	    order_source: 'uncommon_goods',
	    street_address_1: "544 Park Ave",
	    street_address_2: 'Ste 332',
	    city: 'Brooklyn',
	    state: 'NY',
	    postal_code: '11205',
	    country: 'US',
	    phone: '123-321-1231',
	    email: 'Person.McPersonson@gmail.com'
	},
	# 7-line economy order
	{
	    name: 'Peter Person',
	    order_source: 'uncommon_goods',
	    street_address_1: "544 Park Ave",
	    street_address_2: 'Ste 332',
	    city: 'Brooklyn',
	    state: 'NY',
	    postal_code: '11205',
	    country: 'US',
	    phone: '123-321-1231',
	    email: 'Person.McPersonson@gmail.com'
	},
	# "other" order
	{
	    name: 'Susan Person',
		order_source: 'other',
		street_address_1: "544 Park Ave",
	    street_address_2: 'Ste 332',
	    city: 'Brooklyn',
	    state: 'NY',
	    postal_code: '11205',
	    country: 'US',
	    phone: '123-321-1231',
		email: 'Person.McPersonson@gmail.com'
	}
]

created_orders = []
orders_params.each{ |params| created_orders << Order.create(params) }

shipments_params = [
	# Order 0 gets 1 shipment
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[0].id
	},
	# Order 1 gets 1 shipment
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[1].id
	},
	# Order 2 gets 1 shipment
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[2].id
	},
	# Order 3 gets 3 shipments (two 3-packs, one single)
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[3].id
	},
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[3].id
	},
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[3].id
	},
	# Order 4 gets 1 shipment
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[4].id
	}
]

created_shipments = []
shipments_params.each{ |params| created_shipments << Shipment.create(params) }

radios_params = [
	# Radios created from orders params / customer orders
	#
	# Shipment 0 gets 1 radio
	# Shipment 1 gets 2 radios
	# Shipment 2 gets 3 radios
	# Shipment 3 gets 7 radios
	# Shipment 4 gets 1 radio

#	{
#		frequency: '91.5',
#		shipment_id: created_shipments[0].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: '107.5',
#		shipment_id: created_shipments[1].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: '97.1',
#		shipment_id: created_shipments[1].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: '107.5',
#		shipment_id: created_shipments[2].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#    	frequency: '97.1',
#		shipment_id: created_shipments[2].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: '97.1',
#		shipment_id: created_shipments[2].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[3].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[3].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[3].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[3].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[3].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[3].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[3].id,
#		country_code: 'US',
#		boxed: false
#	},
#	{
#		frequency: random_frequency,
#		shipment_id: created_shipments[4].id,
#		country_code: 'US',
#		boxed: false
#	},


	# Boxed Radios, assigned to a shipment and frequency
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[0].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[1].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[1].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[2].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[2].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		frequency: random_frequency,
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[4].id,
		country_code: 'US',
		boxed: true,
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},


	# Assembled Radios in inventory
	{
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
	    quality_control_status: 'passed',
	    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	}

]

radios_params.each{ |params| Radio.create(params) }
