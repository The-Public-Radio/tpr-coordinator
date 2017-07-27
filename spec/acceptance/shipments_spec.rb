require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Shipments" do
  before do
    header "Authorization", "Bearer myaccesstoken"
  end

  fixtures :shipments

  get "/shipments" do
    let(:tracking_number) { 9374889691090496006138 }

    parameter :tracking_number, 'String, shipment tracking number', required: true
    parameter :page, 'String, page number reqested', requied: true
    header('Content-Type', 'application/json')

    example "Looking up a shipment by tacking number" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to_not be nil
    end
  end
end
