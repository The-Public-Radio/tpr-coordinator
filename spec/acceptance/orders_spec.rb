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

  post '/orders' do
    parameter :frequencies, 'String array, frequencies requested. Each entity in the array corresponds to a single radio', required: true
    parameter :name, 'String, first name for the order', required: true
    parameter :address, 'String, address where the order should be shipped', required: true
    parameter :order_source, 'String, where the order came from. Options: kickstarter, squarespace, other', required: false

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
      expect{ do_request(order_params) }.to change(Order, :count).by(1)
      expect(status).to be 201

      data = JSON.parse(response_body)
      expect(data['order_source']).to eq(order_params[:order_source])
      expect(data['name']).to eq(order_params[:name])
      expect(data['email']).to eq(order_params[:email])
    end
  end
end
