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
	{
    name: random_name,
		order_source: 'kickstarter',
		street_address_1: "123 West 9th St.",
    street_address_2: 'Apt 4',
    city: 'Brooklyn',
    state: 'NY',
    postal_code: '11221',
    country: 'US',
    phone: '123-321-1231',
		email: 'Person.McPersonson@gmail.com'
	},
	{
    name: 'Francois Royer Mireault',
		order_source: 'kickstarter',
		street_address_1: "5124 avenue casgrain",
    street_address_2: '',
    city: 'montreal',
    state: 'QC',
    postal_code: 'h2t 17w',
    country: 'CA',
		email: 'Person.McPersonson@gmail.com'
	},
  {
    name: 'Thos Niles',
    order_source: 'other',
    street_address_1: "152 pleasant st apt b",
    street_address_2: '',
    city: 'arlington',
    state: 'MA',
    postal_code: '02476',
    country: 'US',
    phone: '123-321-1231',
    email: 'Person.McPersonson@gmail.com'
  },
  {
    name: 'Tarik Saleh',
    order_source: 'other',
    street_address_1: "1470 42nd st",
    street_address_2: '',
    city: 'los alamos',
    state: 'NM',
    postal_code: '87544',
    country: 'US',
    phone: '123-321-1231',
    email: 'Person.McPersonson@gmail.com'
  },
  {
    name: 'kevin dunham',
    order_source: 'other',
    street_address_1: "19 sills ct",
    street_address_2: '',
    city: 'centerport',
    state: 'NY',
    postal_code: '11721',
    country: 'US',
    phone: '123-321-1231',
    email: 'Person.McPersonson@gmail.com'
  },
	{
    name: random_name,
		order_source: 'other',
		street_address_1: "123 West 9th St.",
    street_address_2: 'Apt 4',
    city: 'Brooklyn',
    state: 'NY',
    postal_code: '11221',
    country: 'US',
    phone: '123-321-1231',
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
		shipment_status: 'label_printed',
		ship_date: Time.now,
		order_id: created_orders[0].id
	},
  # this is Francois' order - shipment 2
	{
		tracking_number: 'LZ780632087US',
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
	},
  # this is thos's order - shipment 5
	{
		tracking_number: '92055901755477000027167920',
		shipment_status: 'label_created',
		ship_date: Time.now,
		order_id: created_orders[2].id
	},
  # this is tarik's order - shipment 6
  {
    tracking_number: '92001901755477000008242445',
    shipment_status: 'label_created',
    ship_date: Time.now,
    order_id: created_orders[3].id
  },
  # this is kevin's order - shipment 7
	{
		tracking_number: '92055901755477000027167937',
		shipment_status: 'label_created',
		ship_date: Time.now,
		order_id: created_orders[4].id
	},]

created_shipments = []
shipments_params.each{ |params| created_shipments << Shipment.create(params) }

radios_params = [
	# Radios created from orders params / customer orders
	#
	# shipment 2 should have one radio
  # shipment 5 should have two radios
  # shipment 6 should have one radio
  # shipment 7 should have three radios
  #
  {
		frequency: '91.5',
		shipment_id: created_shipments[2].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: '107.5',
		shipment_id: created_shipments[5].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: '97.1',
		shipment_id: created_shipments[5].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: '107.5',
		shipment_id: created_shipments[6].id,
		country_code: 'US',
		boxed: false
	},
	{
    frequency: '97.1',
		shipment_id: created_shipments[7].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: '97.1',
		shipment_id: created_shipments[7].id,
		country_code: 'US',
		boxed: false
	},
	{
		frequency: random_frequency,
		shipment_id: created_shipments[7].id,
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
		pcb_version: 'PR9026',
		serial_number: 'TPRv2.0_1_63297',
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
	},
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
	},
	{
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
    quality_control_status: 'failed_mech',
	},
	{
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
    quality_control_status: 'failed_software',
    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},
	{
		pcb_version: 'PR9026',
		serial_number: random_tpr_serial_number,
		assembly_date: Time.now,
		operator: 'Person McPersonson',
    quality_control_status: 'failed_software',
    firmware_version: 'a10fde1a52063d7022efb00924f25e9d915fc66c'
	},

	# Boxed Radios, assigned to a shipment and frequency
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
	}
]

radios_params.each{ |params| Radio.create(params) }
