require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe ShipmentsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Shipment. As you add validations to Shipment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { build(:shipment).attributes }

  let(:invalid_attributes) {
    {
      tracking_number: "not a usps tracking number",
      shipment_status: '93203'
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ShipmentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let(:order) { create(:order) }
  let(:order_id) { order.id }
  let(:international_order) { create(:international_order) }
  let(:international_order_id) { international_order.id }
  let(:warranty_order) { create(:warranty) }
  let(:warranty_order_id) { warranty_order.id }

  before(:each) do
    request.headers['HTTP_AUTHORIZATION'] = "Bearer #{ENV['HTTP_AUTH_TOKENS']}"
  end

  describe "GET #index" do
    it "returns a success response" do
      shipment = Shipment.create! valid_attributes
      get :index, params: {}, session: valid_session
    end

    # USPS Tracking numbers are 20,22,26 or 30 digits. The norm is 26 for Shippo.
    # 34 digit tracking numbers are an application code + zip code + 26 digit tracking number
    it "shortens a 34 digit USPS tracking number to a 26 digit one" do
      shipment = create(:label_created)

      get :index, params: { tracking_number: "42010001#{shipment.tracking_number}"}, session: valid_session

      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)['data']
      expect(data['tracking_number']).to eq(shipment.tracking_number)
    end

    it "handles a failed look up by tracking number and returns a 404 and errors" do
      shipment = create(:label_created)
      tracking_number = "42010008881#{shipment.tracking_number}"

      expect{ get :index, params: { tracking_number: tracking_number}, session: valid_session }
        .to raise_error(NoShipmentFound)

      expect(response).to have_http_status(:not_found)
      data = JSON.parse(response.body)['data']
      errors = JSON.parse(response.body)['errors']
      expect(data).to eq []
      expect(errors).to eq ["Error looking up shipment #{tracking_number}"]
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      shipment = Shipment.create! valid_attributes
      get :show, params: {id: shipment.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Shipment" do
        expect {
          post :create, params: { order_id: order_id, shipment: valid_attributes }, session: valid_session
        }.to change(Shipment, :count).by(1)
      end

      it "renders a JSON response with the new shipment" do
        post :create, params: { order_id: order_id, shipment: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end

      it "defaults to economy shipment priority" do
        post :create, params: { order_id: order_id, shipment: valid_attributes }, session: valid_session
        body = JSON.parse(response.body)['data']
        
        expect(response).to have_http_status(:created)
        expect(body['shipment_priority']).to eq 'economy'
      end

      context 'without a tracking number' do

        let(:create_shipment_params)  { {
          shipment: {
            address_from: {
              :name => 'Centerline Labs',
              :company => '',
              :street1 => '814 Lincoln Pl',
              :street2 => '#2',
              :city => 'Brooklyn',
              :state => 'NY',
              :zip => '11216',
              :country => 'US',
              :phone => '123-456-7890',
              :email => 'info@thepublicrad.io'
            },
            address_to: {
              :name => order.name,
              :company => '',
              :street1 => '123 West 9th St.',
              :street2 => 'Apt 4',
              :city => 'Brooklyn',
              :state => 'NY',
              :zip => '11221',
              :country => 'US',
              :phone => '123-321-1231',
              :email => order.email
            },
            parcels: {
              :length => 5,
              :width => 4,
              :height => 3,
              :distance_unit => :in,
              :weight => 12,
              :mass_unit => :oz
            },
            carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"]              
          }
        }}
        
        let(:shippo_create_shipment_response) { object_double('shippo response', code: 200,
          'status'=> 'SUCCESS', resource_id: "shippo_reference_id", rates: [
            {"resource_id": "test_rate_id", "servicelevel": { "token": "usps_priority" }},
            {"resource_id": "test_rate_id2", "servicelevel": { "token": "usps_first_priority" }}
            ])
        }

        let(:choosen_shippo_rate) {
          "test_rate_id"
        }

        let(:shippo_create_transaction_response) { object_double('shippo response', code: 200,
          'status'=> 'SUCCESS', tracking_number: '9400111298370829688891',
          label_url: 'https://shippo-delivery-east.s3.amazonaws.com/some_label.pdf')
        }

        let(:valid_shipping_attributes) do
          valid_attributes.delete('tracking_number')
          valid_attributes['frequencies'] = [{'frequency': '98.1', 'country': 'CA'}]
          valid_attributes
        end

        before(:each) do
          create_shipment_params[:shipment][:address_to][:name] = order.name
        end

        context 'and succeeds to' do

          def execute_post
            post :create, params: { order_id: order_id, shipment: valid_shipping_attributes }, session: valid_session
          end

          def expect_rate_and_label
            expect(ShippoHelper).to receive(:choose_rate).and_return(choosen_shippo_rate).once
            expect(ShippoHelper).to receive(:create_label).and_return(shippo_create_transaction_response).once
            expect(shippo_create_shipment_response).to receive(:[]).with('object_id').and_return('test_object_id')
          end

          def expect_shipment_object_params
            body = JSON.parse(response.body)['data']
            created_shipment = Shipment.find(body['id'])
            expect(created_shipment.rate_reference_id).to eq choosen_shippo_rate
            expect(created_shipment.tracking_number).to eq(shippo_create_transaction_response.tracking_number)
            expect(created_shipment.label_url).to eq(shippo_create_transaction_response.label_url)
            expect(created_shipment.shipment_status).to eq 'label_created'
          end

          it 'creates a shipment in shippo, stores the choosen rate, creates a label, and stores the label_url' do
            expect(ShippoHelper).to receive(:create_shipment).and_return(shippo_create_shipment_response).once
            expect_rate_and_label
            execute_post
            expect_shipment_object_params
          end

          it 'creates international orders' do
            valid_shipping_attributes[:order_id] = international_order_id
            expect(ShippoHelper).to receive(:create_international_shipment).and_return(shippo_create_shipment_response).once
            expect_rate_and_label
            post :create, params: { order_id: international_order_id, shipment: valid_shipping_attributes }, session: valid_session
            expect_shipment_object_params
          end

          skip 'creates a return label if the order_source is warranty' do
            expect(ShippoHelper).to receive(:create_shipment_with_return).and_return(shippo_create_shipment_response).once
            expect(ShippoHelper).to receive(:create_shipment).and_return(shippo_create_shipment_response).once
            expect(ShippoHelper).to receive(:choose_rate).and_return(choosen_shippo_rate).twice
            expect(ShippoHelper).to receive(:create_label).and_return(shippo_create_transaction_response).twice
            expect(shippo_create_shipment_response).to receive(:[]).with('object_id').and_return('test_object_id')
            
            valid_shipping_attributes[:order_id] = warranty_order_id
            post :create, params: { order_id: warranty_order_id, shipment: valid_shipping_attributes }, session: valid_session
            expect_shipment_object_params

            # Duplicated from expect_shipment_object_params due to need to check return_label_url
            body = JSON.parse(response.body)['data']
            created_shipment = Shipment.find(body['id'])
            expect(created_shipment.return_label_url).to eq(shippo_create_transaction_response.label_url)
          end

          it 'creates express shipments' do
            expect(ShippoHelper).to receive(:create_shipment).and_return(shippo_create_shipment_response).once     
            valid_attributes['shipment_priority'] = 'express'
            create_shipment_params[:servicelevel_token] = 'usps_priority_express'
            expect_rate_and_label
            execute_post
            expect_shipment_object_params
            expect(Shipment.last.shipment_priority).to eq('express')
            expect(Shipment.last.priority_processing).to be true
          end

          it 'creates priority shipments' do
            expect(ShippoHelper).to receive(:create_shipment).and_return(shippo_create_shipment_response).once        
            valid_attributes['shipment_priority'] = 'priority'
            create_shipment_params[:servicelevel_token] = 'usps_priority'
            expect_rate_and_label
            execute_post
            expect_shipment_object_params
            expect(Shipment.last.shipment_priority).to eq('priority')
          end
        end
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new shipment" do

        post :create, params: {shipment: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          shipment_status: 'shipped'
        }
      }

      it "updates the requested shipment" do
        shipment = Shipment.create! valid_attributes
        put :update, params: {id: shipment.to_param, shipment: new_attributes}, session: valid_session
        shipment.reload
        expect(shipment.shipment_status).to eq(new_attributes[:shipment_status])
      end

      it "renders a JSON response with the shipment" do
        shipment = Shipment.create! valid_attributes

        put :update, params: {id: shipment.to_param, shipment: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end

      it 'updates the ship_date when the status changes to shipped' do
        expected_date = '2017-09-03'
        Timecop.freeze('2017-09-04')

        shipment = Shipment.create! valid_attributes

        put :update, params: {id: shipment.to_param, shipment: { shipment_status: 'shipped' }}, session: valid_session
        expect(response).to have_http_status(:ok)
        data = JSON.parse(response.body)['data']
        expect(data['ship_date']).to eq(expected_date)
        expect(Shipment.find(shipment.id).ship_date).to eq(expected_date)
      end

      it 'updates the ship_date when the status changes to shipped' do
        expected_date = '2017-09-03'
        Timecop.freeze('2017-09-04')

        shipment = Shipment.create! valid_attributes

        put :update, params: {id: shipment.to_param, shipment: { shipment_status: 'shipped' }}, session: valid_session
        expect(response).to have_http_status(:ok)
        data = JSON.parse(response.body)['data']
        expect(data['ship_date']).to eq(expected_date)
        expect(Shipment.find(shipment.id).ship_date).to eq(expected_date)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the shipment" do
        shipment = Shipment.create! valid_attributes

        put :update, params: {id: shipment.to_param, shipment: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested shipment" do
      shipment = Shipment.create! valid_attributes
      expect {
        delete :destroy, params: {id: shipment.to_param}, session: valid_session
      }.to change(Shipment, :count).by(-1)
    end
  end
end
