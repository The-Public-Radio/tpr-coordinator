require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Radios" do
  before do
    header "Authorization", "Bearer myaccesstoken"
  end

  let(:fulfillment_shipment) { create :fulfillment }
  let(:shipment_id) { fulfillment_shipment.id }
  let(:radio) { create(:radio) }

  get "/shipments/:shipment_id/radios/:id" do
    header('Content-Type', 'application/json')
    let(:id) { radio.id }
    example "Look up a single radio" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['frequency']).to eq('90.5')
    end
  end

  get "/shipments/:shipment_id/radios" do

    header('Content-Type', 'application/json')

    let(:page) { 2 }
    parameter :page, 'String, paganation page number', required: false

    example "Look up a shipment's radios" do
      create(:radio_2)
      create(:radio_3)
      create(:radio_4)

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      binding.pry
      expect(data['shipment_id']).to eq(shipment_id)
      expect(data['radio']['frequency'].length).to eq('87.9')
    end
  end

  get "/shipments/:shipment_id/radios" do
    let(:id) { created_shipment.id }
    let(:page) { '1' }

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
