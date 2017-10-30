require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Shipments" do
  before do
    header "Authorization", "Bearer myaccesstoken"
    header('Content-Type', 'application/json')
  end

  let(:created_shipment) { create :created }
  let(:label_created_shipment) { create :label_created }
  let(:shipped_shipment) { create :shipped }
  let(:order) { create(:squarespace) }

  get "/shipments/:id" do
    let(:id) { shipped_shipment.id }
    example "Looking up a single shipment" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['tracking_number'].length).to be shipped_shipment.tracking_number.length
      expect(data['ship_date']).to eq('2017-07-28')
      expect(data['shipment_status']).to eq('shipped')
    end
  end

  get "/shipments" do
    example "All shipments" do
      shipped_shipment
      created_shipment
      label_created_shipment

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to be 3
    end
  end

  get "/shipments" do
    parameter :tracking_number, 'String, shipment tracking number', required: true
    let(:ship) { create(:shipped) }
    let(:tracking_number) { ship.tracking_number }
    let(:ship_date) {ship.ship_date}

    example "Looking up a shipment by tacking number" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['tracking_number'].length).to be tracking_number.length
      expect(data['ship_date']).to eq(ship_date)
      expect(data['shipment_status']).to eq('shipped')
    end
  end

  get "/shipments" do
    parameter :shipment_status, 'String, shipment status', required: true
    let(:shipment_status) { 'label_created' }

    example "Look up all shipments that have unprinted labels" do
      shipments = create_list(:label_created, 2)

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to be 2
      expect(data[0]['id']).to eq(shipments[0].id)
      expect(data[0]['label_data']).to eq(shipments[0].label_data)
    end
  end

  get "/next_shipment_to_print" do
    example "Look the next shipments with an unprinted label from order_source kickstarter, squarespace, or other" do
      explanation "This endpoint also respects the priority field on a shipment; returning those shipments with priority: true first."
      create_list(:label_printed, 2)
      create_list(:shipped, 2)
      shipments = create_list(:label_created, 2)
      priority_shipment = create_list(:priority_processing, 2)

      # Set order to something not kickstarter, squarespace, other
      order = shipments[0].order
      order.order_source = 'WBEZ'
      order.save
      
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['id']).to eq(priority_shipment[0].id)
      expect(data['label_data']).to eq(priority_shipment[0].label_data)
    end
  end

  get "/shipment_label_created_count" do
    example "Look the number of shipments with an unprinted label." do
      shipments = create_list(:label_created, 2)

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['shipment_count']).to be 2
    end
  end

  put "/shipments/:id" do
    let(:tracking_number) { created_shipment.tracking_number }
    let(:shipment_status) { 'label_created' }
    let(:before_shipment_status) { created_shipment.shipment_status }

    parameter :tracking_number, 'String, shipment tracking number', required: false
    parameter :shipment_status, 'String, shipment status', required: true

    example "Update a shipment's status" do

      expect(before_shipment_status).to eq('created')

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['shipment_status']).to eq(shipment_status)

      expect{ created_shipment.reload }.to change { created_shipment.shipment_status }
        .from(before_shipment_status).to(shipment_status)
    end
  end

  get "/shipments?order_id=:order_id" do
    let(:order_id) { order.id }
    example "Find a shipments that are attached to an order" do
      create(:kickstarter)
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.count).to eq(2)
      data.each do |shipment|
        expect(shipment['order_id']).to eq(order.id)
      end
    end
  end

  get "/shipments/:id/next_radio" do
    let(:id) { label_created_shipment.id }

    parameter :tracking_number, 'String, shipment tracking number', required: true

    let(:tracking_number) { label_created_shipment.tracking_number }

    example "Looking the next unboxed radio in a shipment" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['boxed']).to be false
      expect(data['frequency']).to eq(label_created_shipment.radio[1].frequency)
    end
  end
end
