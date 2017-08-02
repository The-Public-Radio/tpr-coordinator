require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Shipments" do
  before do
    header "Authorization", "Bearer myaccesstoken"
  end

  let(:created_shipment) { create :created }
  let(:fulfillment_shipment) { create :fulfillment }
  let(:shipped_shipment) { create :shipped }

  get "/shipments/:id" do
    header('Content-Type', 'application/json')
    let(:id) { shipped_shipment.id }
    example "Looking up a single shipment" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['tracking_number']).to eq('9374889691090496006138')
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

    parameter :tracking_number, 'String, shipment tracking number', required: true
    header('Content-Type', 'application/json')

    example "Looking up a shipment by tacking number" do
      shipped_shipment

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      binding.pry
      expect(data[0]['tracking_number']).to eq('9374889691090496006138')
      expect(data[0]['ship_date']).to eq('2017-07-27')
      expect(data['shipment_status']).to eq('shipped')
    end
  end

  put "/shipments" do
    let(:tracking_number) { '9374889691090496006138' }
    let(:shipment_status) { 'fulfillment' }
    let(:id) { created_shipment.id }

    parameter :tracking_number, 'String, shipment tracking number', required: true
    parameter :shipment_status, 'String, shipment tracking number', required: true
    header('Content-Type', 'application/json')

    example "Update a shipment's status" do
      expect(Shipment.find(id).shipment_status).to eq('created')

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['shipment_status']).to eq('fulfillment')
    end
  end

  get "/shipment/:id/radios" do
    header('Content-Type', 'application/json')

    let(:tracking_number) { '9374889691090496006138' }
    let(:page) { 2 }
    parameter :tracking_number, 'String, shipment tracking number', required: true

    example "Look up radios by a shipment's tracking number" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['radios'].length).to eq('2')
    end
  end

  get "/shipment/:id/radios" do
    parameter :tracking_number, 'String, shipment tracking number', required: true
    parameter :page, 'String, page number reqested', requied: true

    example "Paginated radios by a shipment's tracking number" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(headers['X-Page']).to eq('2')
      expect(data['radio']['frequency']).to eq('90.5')
    end
  end
end
