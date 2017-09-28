require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Radios" do
  before do
    header "Authorization", "Bearer myaccesstoken"
    header('Content-Type', 'application/json')
  end

  let(:label_created_shipment) { create :label_created }
  let(:shipment_id) { label_created_shipment.id }
  let(:radio_assembled) { create(:radio_assembled) }
  let(:radio_boxed) { create(:radio_boxed) }

  get "/radios/:id" do
    let(:id) { radio_boxed.id }
    example "Look up a single radio" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['frequency']).to eq(radio_boxed.frequency)
    end
  end

  get "/shipments/:shipment_id/radios" do
    example "Look up a shipment's radios" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to be 3
    end
  end 

  get "/radios" do
    example "Look up all radios" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.count).to be Radio.all.count 
    end
  end 

  get "/radios" do
    parameter :serial_number, 'String, serial number of a radio', required: true
    let(:serial_number) { radio_boxed.serial_number }

    example "Look a radio by serial number" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['id']).to eq radio_boxed.id
      expect(data['serial_number']).to eq radio_boxed.serial_number
    end
  end 

  get "/shipments/:shipment_id/radios" do
    parameter :page, 'String, paganation page number', required: false
    let(:page) { 2 }
    let(:frequency) { Shipment.find(shipment_id).radio[1].frequency}

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
    parameter :country_code, 'String, country code for the radio. One of us, jp, eu', required: false

    let(:pcb_version) { '1' }
    let(:serial_number) { random_tpr_serial_number }
    let(:operator) { random_name }
    let(:country_code) { 'US' }

    example "Create a radio" do
      expect{ do_request }.to change( Radio, :count ).by(1)
      expect(status).to eq 201
      data = JSON.parse(response_body)['data']

      expect(data['pcb_version']).to eq(pcb_version)
      expect(data['serial_number']).to eq(serial_number)
      expect(data['operator']).to eq(operator)
    end
  end

  put "/shipments/:shipment_id/radios" do
    parameter :boxed, 'Boolean, is this radio boxed?', required: true
    parameter :serial_number, 'String, radio (speaker) serial number', required: true

    let(:boxed) { true }
    let(:serial_number) { radio_assembled.serial_number }

    example "Update a radio to be boxed and attached to a shipment" do
      shipment =  Shipment.find(shipment_id)
      assembled_radio =  Radio.find_by_serial_number(serial_number)
      next_unboxed_radio = shipment.next_unboxed_radio
      radios_in_shipment = shipment.radio.count

      expect(next_unboxed_radio.boxed).to be false
      expect(next_unboxed_radio.serial_number).to be nil
     
      do_request

      expect(status).to eq 200
      data = JSON.parse(response_body)['data']

      expect(data['boxed']).to be true
      expect(data['serial_number']).to eq(serial_number)
      
      next_unboxed_radio.reload 

      expect(shipment.reload.radio.count).to be radios_in_shipment
      expect(next_unboxed_radio.shipment_id).to eq shipment_id
      expect(next_unboxed_radio.serial_number).to eq assembled_radio.serial_number
      expect(next_unboxed_radio.operator).to eq assembled_radio.operator
      expect(next_unboxed_radio.assembly_date).to eq assembled_radio.assembly_date
      expect(next_unboxed_radio.quality_control_status).to eq assembled_radio.quality_control_status
      expect(next_unboxed_radio.firmware_version).to eq assembled_radio.firmware_version
      expect(next_unboxed_radio.boxed).to be true
      expect{ assembled_radio.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
