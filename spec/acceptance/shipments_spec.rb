require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Shipments" do
  before do
    header "Authorization", "Bearer myaccesstoken"
  end

  before(:each) do
    create :shipment, :created, :fulfillment, :shipped
  end

  get "/shipments/:id" do
    create :shipment, :created, :fulfillment, :shipped
    binding.pry
    header('Content-Type', 'application/json')
    let(:id) { 1 }
    example "Looking up a single shipment" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['tracking_number']).to eq('9374889691090346006029')
      expect(data['ship_date']).to eq('2017-07-28')
      expect(data['shipment_status']).to eq('fulfillment')
    end
  end

  get "/shipments" do
    example "All shipments" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to_not be nil
    end

    let(:tracking_number) { '9374889691090496006138' }
    parameter :tracking_number, 'String, shipment tracking number', required: true
    header('Content-Type', 'application/json')

    example "Looking up a shipment by tacking number" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['tracking_number']).to eq('9374889691090496006138')
      expect(data['ship_date']).to eq('2017-07-27')
      expect(data['shipment_status']).to eq('shipped')
    end
  end

  put "/shipments" do
    let(:tracking_number) { '9374889691090496006138' }
    let(:shipment_status) { 'fulfillment' }

    parameter :tracking_number, 'String, shipment tracking number', required: true
    parameter :shipment_status, 'String, shipment tracking number', required: true
    header('Content-Type', 'application/json')

    example "Update a shipment's status" do
      expect(Shipment.find(1).shipment_status).to eq('created')

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
