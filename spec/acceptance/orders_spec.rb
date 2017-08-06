require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Orders" do
  before do
    header "Authorization", "Bearer myaccesstoken"
    header 'Content-Type', 'application/json' 
  end

  let(:kickstarter_order) { create :kickstarter }
  let(:squarespace_order) { create :squarespace }

  get "/orders" do
    example "All orders" do
      kickstarter_order
      squarespace_order
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to be 2
    end
  end

  get "/order/:id" do
    let(:id) { kickstarter_order.id }
    example "Looking up a single order" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['order_source']).to eq(kickstarter_order.order_source)
      expect(data['first_name']).to eq(kickstarter_order.first_name)
      expect(data['last_name']).to eq(kickstarter_order.last_name)
      expect(data['email']).to eq(kickstarter_order.email)
    end
  end

  post '/orders' do
    parameter :frequencies, 'String array, frequencies requested. Each entity in the array corresponds to a single radio', required: true
    parameter :first_name, 'String, first name for the order', required: true
    parameter :last_name, 'String, last name for the order', required: true
    parameter :address, 'String, address where the order should be shipped', required: true
    parameter :order_source, 'String, where the order came from. Options: kickstarter, squarespace, other', required: false

    example 'Create a new order' do
      prior_shipment_count = Shipment.all.count
      prior_radio_count = Radio.all.count

      expect {
        do_request(
          order_source: 'other',
          first_name: 'Person',
          last_name: 'McPersonson',
          address: '345 West Way, Brooklyn, NY, 11221',
          frequencies: ['98.3', '79.5', '79.5', '98.3', '79.5', '79.5', '98.3', '79.5', '79.5', '105.6']
        )
        }.to change(Order, :count).by(1)
      expect(status).to be :created
      data = JSON.parse(response_body)['data']

      expect(data['shipments'].count).to be 4
      expect(data['shipments'][0]['radios'].count).to be 3
      expect(data['shipments'][1]['radios'].count).to be 3
      expect(data['shipments'][2]['radios'].count).to be 2
      expect(data['shipments'][3]['radios'].count).to be 2

      expect(Shipment.all.count).to be(prior_shipment_count + 4)
      expect(Radio.all.count).to be(prior_radio_count + 4)
    end
  end
end
