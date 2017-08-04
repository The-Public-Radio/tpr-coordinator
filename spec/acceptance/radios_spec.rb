require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Radios" do
  before do
    header "Authorization", "Bearer myaccesstoken"
    header('Content-Type', 'application/json')
  end

  let(:fulfillment_shipment) { create :fulfillment }
  let(:shipment_id) { fulfillment_shipment.id }
  let(:radio) { create(:radio) }
  let(:radio_frequency) { radio.frequency }

  get "/shipments/:shipment_id/radios/:id" do
    let(:id) { radio.id }
    example "Look up a single radio" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['frequency']).to eq('90.5')
    end
  end

  get "/shipments/:shipment_id/radios" do
    example "Look up a shipment's radios" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data[1]['frequency']).to eq(radio_frequency)
      expect(data.length).to be 3
    end
  end 

  get "/shipments/:shipment_id/radios" do
    parameter :page, 'String, paganation page number', required: false
    let(:page) { 2 }

    example "Look up a shipment's radios one (page) at a time " do
      copy { 'Each page only returns 1 record. The header `X-Total` will give the total number of radios (pages)' }
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['shipment_id']).to eq(shipment_id)
      expect(data['radio']['frequency']).to eq('87.9')
    end
  end
end
