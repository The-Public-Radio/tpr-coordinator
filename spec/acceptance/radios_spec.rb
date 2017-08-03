require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Radios" do
  before do
    header "Authorization", "Bearer myaccesstoken"
    create(:radio)
  end

  get "/radios/:id" do
    header('Content-Type', 'application/json')
    let(:id) { 1 }
    example "Look up a single radio" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['frequency']).to eq('90.5')
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
