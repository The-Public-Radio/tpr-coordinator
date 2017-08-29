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

orders_params = [
	{
		first_name: 'Person',
		last_name: 'McPersonson',
		order_source: 'kickstarter',
		address: '132 N 5th St, Brooklyn, NY 11221',
		email: 'Person.McPersonson@gmail.com'
	},
	{
		first_name: 'Person',
		last_name: 'McPersonson',
		order_source: 'squarespace',
		address: '132 N 5th St, Brooklyn, NY 11221',
		email: 'Person.McPersonson@gmail.com'
	},	
	{
		first_name: 'Person',
		last_name: 'McPersonson',
		order_source: 'other',
		address: '132 N 5th St, Brooklyn, NY 11221',
		email: 'Person.McPersonson@gmail.com'
	}]

created_orders = []
orders_params.each{ |params| created_orders << Order.create(params) }

shipments_params = [
	{
		tracking_number: random_tracking_number,
		shipment_status: 'created',
		ship_date: Time.now,
		order_id: created_orders[0].id
	},
  {
		tracking_number: random_tracking_number,
		shipment_status: 'label_created',
		ship_date: Time.now,
		order_id: created_orders[0].id
	},
	# This shipment is an actual tracking number and not a randomly generated one
	{
		tracking_number: '9400111298370828166024',
		shipment_status: 'label_created',
		ship_date: Time.now,
		order_id: created_orders[1].id
	},
	{
		tracking_number: random_tracking_number,
		shipment_status: 'boxed',
		ship_date: Time.now,
		order_id: created_orders[2].id
	},
	{
		tracking_number: random_tracking_number,
		shipment_status: 'shipped',
		ship_date: Time.now,
		order_id: created_orders[2].id
	}]

created_shipments = []
shipments_params.each{ |params| created_shipments << Shipment.create(params) }

radios_params = [
	# Radios created from orders params / customer orders
	# 
	# The first 3 here have known NYC frequencies for testing, the rest are random
  {
		frequency: '93.9',
		shipment_id: created_shipments[2].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: '97.1',
		shipment_id: created_shipments[2].id,
		country_code: 'US',
		boxed: false
	},	
	{
		frequency: '101.1',
		shipment_id: created_shipments[2].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: random_frequency,
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: random_frequency,
		shipment_id: created_shipments[3].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: random_frequency,
		shipment_id: created_shipments[1].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: random_frequency,
		shipment_id: created_shipments[0].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: random_frequency,
		shipment_id: created_shipments[0].id,
		country_code: 'US',
		boxed: false
	},


	# Assembled Radios
	# 
	# First assembled radio has a known serial nubmer for testing
	{
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_63297',
		assembly_date: Time.now,
		operator: 'Person McPersonson'
	},
	{
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson'
	},	
	{
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson'
	},
	{
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson'
	},
	{
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson'
	},
	{
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson'
	},
	{
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson'
	},


	# Boxed Radios, assigned to a shipment and frequency
	{
		frequency: random_frequency,
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[4].id,
		country_code: 'US',
		boxed: true
	},
	{
		frequency: random_frequency,
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[4].id,
		country_code: 'US',
		boxed: true
	},
	{
		frequency: random_frequency,
		pcb_version: '1',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: created_shipments[4].id,
		country_code: 'US',
		boxed: true
	}
]

radios_params.each{ |params| Radio.create(params) }
