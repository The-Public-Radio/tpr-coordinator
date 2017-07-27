require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Shipments" do
  before do
    header "Authorization", "Bearer myaccesstoken"
  end

  fixtures :shipments

  get "/shipments" do
    example "All shipments" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to_not be nil
    end

    let(:tracking_number) { 9374889691090496006138 }
    parameter :tracking_number, 'String, shipment tracking number', required: false
    parameter :page, 'String, page number reqested', requied: true
    header('Content-Type', 'application/json')

    example "Looking up a shipment by tacking number" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      puts data
      expect(data['tracking_number']).to eq('9374889691090496006138')
      expect(data['ship_date']).to eq('2017-07-27')
      expect(data['status']).to eq('created')
    end
  end
end
