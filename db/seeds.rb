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

radios = [
	{
		frequency: '98.1',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_12345',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 22
	},
	{
		frequency: '79.3',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_12345',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 22
	},	
	{
		frequency: '103.1',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_12345',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 22
	},
	{
		frequency: '103.1',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_12345',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 22
	},
	{
		frequency: '103.1',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_12345',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 23
	},
	{
		frequency: nil,
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_12345',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: nil
	},
	{
		frequency: nil,
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_12345',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: nil
	},
	{
		frequency: '101.1',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_92007',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 25,
		boxed: false
	},
	{
		frequency: '97.1',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_49079',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 25,
		boxed: false
	},
	{
		frequency: '93.9',
		pcb_version: '1',
		serial_number: 'TPRv2.0_1_53012',
		assembly_date: Time.now,
		operator: 'Person McPersonson',
		shipment_id: 25,
		boxed: false
	}]

shipments = [
	{
		tracking_number: '9374889691090496850816',
		shipment_status: 'created',
		ship_date: Time.now,
		order_id: 24
	},
	{
		tracking_number: '9937488969109049676230',
		shipment_status: 'fulfillment',
		ship_date: Time.now,
		order_id: 24
	},
	{
		tracking_number: '9374889691090496296829',
		shipment_status: 'shipped',
		ship_date: Time.now,
		order_id: 23
	},
	{
		tracking_number: '9400111298370828166024',
		shipment_status: 'shipped',
		ship_date: Time.now,
		order_id: 23
	}]

orders = [
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

orders.each{ |order| Order.create(order) }
shipments.each{ |order| Shipment.create(order) }
radios.each{ |order| Radio.create(order) }
