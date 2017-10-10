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

  get "/orders/:id" do
    let(:id) { kickstarter_order.id }
    example "Looking up a single order" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)
      expect(data['order_source']).to eq(kickstarter_order.order_source)
      expect(data['name']).to eq(kickstarter_order.name)
      expect(data['email']).to eq(kickstarter_order.email)
    end
  end

  get "/orders" do
    parameter :order_source, 'String, the source for the order; valid values: kickstarter, squarespace, WBEZ, other', required: true

    let(:order_source) { 'squarespace' }
    example "Lookup orders with a particular order_source" do
      order = create(:squarespace)

      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data.length).to be 1
      data.each do |returned_order|
        expect(returned_order['order_source']).to eq(order.order_source)
        expect(returned_order['id']).to eq(order.id)
      end
    end
  end

  post '/orders' do
    parameter :frequencies, 'String array, frequencies requested. Each entity in the array corresponds to a single radio', required: true
    parameter :name, 'String, first name for the order', required: true
    parameter :address, 'String, address where the order should be shipped', required: true
    parameter :order_source, 'String, where the order came from. Options: kickstarter, squarespace, other', required: false

    let(:tracking_number) { random_tracking_number }

    example 'Create a new order' do
      order_params = {
        order_source: 'other',
        name: random_name,
        address: '345 West Way, Brooklyn, NY, 11221',
        frequencies: {
          'us': ['98.3', '79.5', '79.5', '98.3', '79.5', '79.5', '98.3', '79.5', '79.5', '105.6']
          },
        email: 'person.mcpersonson@gmail.com'
      }

      shippo_response_object = object_double('shippo response', code: 200, 
        status: 'SUCCESS', success?: true, tracking_number: '9400111298370829688891', 
        label_url: 'https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf')

      s3_label_object = object_double('s3_label_object', code: 200, body: 'somelabelpdf') 

      expect(HTTParty).to receive(:get).with(shippo_response_object.label_url).and_return(s3_label_object).exactly(4)
      expect(Shippo::Transaction).to receive(:create).and_return(shippo_response_object).exactly(4)
      expect(shippo_response_object).to receive(:[]).with('status').and_return('SUCCESS').exactly(4)
      expect(shippo_response_object).to receive(:tracking_number).and_return('9400111298370829688891').exactly(4)
      expect(shippo_response_object).to receive(:label_url).and_return('https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf').exactly(4)
      expect{ do_request(order_params) }.to change(Order, :count).by(1)
      expect(status).to be 201

      data = JSON.parse(response_body)
      expect(data['order_source']).to eq(order_params[:order_source])
      expect(data['name']).to eq(order_params[:name])
      expect(data['email']).to eq(order_params[:email])
    end
  end
end
