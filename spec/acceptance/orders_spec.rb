require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Orders" do
  before do
    header "Authorization", "Bearer myaccesstoken"
    header 'Content-Type', 'application/json' 
  end


  get "/orders" do
    let(:squarespace_order) { create :squarespace }
    let(:kickstarter_order) { create :kickstarter }
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
    let(:kickstarter_order) { create :kickstarter }
    let(:id) { kickstarter_order.id }
    example "Looking up a single order" do
      puts kickstarter_order
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
      create(:kickstarter)

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
end
