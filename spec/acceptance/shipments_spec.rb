require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Shipments" do
  before do
    header "Authorization", "Bearer myaccesstoken"
  end

  fixtures :shipments

  get "/shipments/:id" do
    header('Content-Type', 'application/json')
    let(:id) { 2 }
    example "Looking up a single shipment" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      puts data
      expect(data['tracking_number']).to eq('9374889691090346006029')
      expect(data['ship_date']).to eq('2017-07-28')
      expect(data['shipment_status']).to eq('fulfillment')
    end
  end

  get "/shipments" do
    parameter :page, 'String, page number reqested', requied: true

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
      puts data
      expect(data['tracking_number']).to eq('9374889691090496006138')
      expect(data['ship_date']).to eq('2017-07-27')
      expect(data['shipment_status']).to eq('created')
    end
  end

  put "/shipments" do
    let(:tracking_number) { '9374889691090496006138' }
    let(:shipment_status) { 'fulfillment' }

    parameter :tracking_number, 'String, shipment tracking number', required: true
    parameter :shipment_status, 'String, shipment tracking number', required: true
    header('Content-Type', 'application/json')

    example "Update a shipment's status" do
      do_request
      expect(Shipment.find(1).shipment_status).to eq('created')

      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['status']).to eq('fulfillment')
    end
  end
end
