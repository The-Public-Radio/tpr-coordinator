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
  let(:frequency) { radio.frequency }
  let(:radio_id) { radio.id }
  let(:radio_serial_number) { radio.serial_number }

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
      expect(data[1]['frequency']).to eq(frequency)
      expect(data.length).to be 3
    end
  end 

  get "/shipments/:shipment_id/radios" do
    parameter :page, 'String, paganation page number', required: false
    let(:page) { 2 }

    example "Look up a shipment's radios one (page) at a time " do
      explanation 'Each page only returns 1 record. The header `X-Total` will give the total number of radios (pages)'
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)

      expect(data.count).to be 1
      expect(data[0]['frequency']).to eq(frequency)
      expect(response_headers['X-Total']).to eq('3')
    end
  end

  post "/radios" do
    parameter :frequency, 'String, frequency for the radio', required: false
    parameter :pcb_version, 'String, PCB revision', required: false
    parameter :serial_number, 'String, radio (speaker) serial number', required: false
    parameter :operator, 'String, paganation page number', required: false

    let(:pcb_version) { '1' }
    let(:serial_number) { radio_serial_number }
    let(:operator) { 'Operator McOperatorson' }

    example "Create a radio" do
      do_request
      expect(status).to eq 201
      data = JSON.parse(response_body)['data']

      expect(data['pcb_version']).to eq(pcb_version)
      expect(data['serial_number']).to eq(radio_serial_number)
      expect(data['operator']).to eq(operator)
    end
  end

  put "/radios" do
    parameter :boxed, 'Boolean, is this radio boxed?', required: true
    parameter :serial_number, 'String, radio (speaker) serial number', required: true
    parameter :shipment_id, 'String, shipment_id that the radio was boxed for', required: true

    let(:boxed) { true }
    let(:serial_number) { radio_serial_number }

    example "Update a radio to be boxed and attached to a shipment" do
      radio =  Radio.find_by_serial_number(serial_number)

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      errors = JSON.parse(response_body)['errors']

      expect(data['boxed']).to be true
      expect(data['serial_number']).to eq(serial_number)
      expect(data['shipment_id']).to eq(shipment_id)

      expect{ radio.reload }.to change{ radio.boxed }.from(false).to(true)
      expect(errors.empty?).to be true
    end
  end
end
