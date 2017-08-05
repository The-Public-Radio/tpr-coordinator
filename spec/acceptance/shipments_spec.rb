require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Shipments" do
  before do
    header "Authorization", "Bearer myaccesstoken"
    header('Content-Type', 'application/json')
  end

  let(:created_shipment) { create :created }
  let(:fulfillment_shipment) { create :fulfillment }
  let(:shipped_shipment) { create :shipped }

  get "/shipments/:id" do
    let(:id) { shipped_shipment.id }
    example "Looking up a single shipment" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['tracking_number'].length).to be 22
      expect(data['ship_date']).to eq('2017-07-28')
      expect(data['shipment_status']).to eq('shipped')
    end
  end

  get "/shipments" do
    example "All shipments" do
      shipped_shipment
      created_shipment
      fulfillment_shipment

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
      expect(data['tracking_number'].length).to be 22
      expect(data['ship_date']).to eq(ship_date)
      expect(data['shipment_status']).to eq('shipped')
    end
  end

  put "/shipments" do
    let(:tracking_number) { created_shipment.tracking_number }
    let(:shipment_status) { 'fulfillment' }
    let(:before_shipment_status) { created_shipment.shipment_status }

    parameter :tracking_number, 'String, shipment tracking number', required: true
    parameter :shipment_status, 'String, shipment tracking number', required: true

    example "Update a shipment's status" do
      expect(before_shipment_status).to eq('created')

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['shipment_status']).to eq(shipment_status)
    end
  end
end
