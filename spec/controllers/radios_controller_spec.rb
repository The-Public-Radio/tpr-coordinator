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

RSpec.describe RadiosController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Radio. As you add validations to Radio, be sure to
  # adjust the attributes here as well.
  let(:shipment) { create(:shipment) }
  let(:shipment_id) { shipment.id }

  let(:valid_attributes) { build(:radio_boxed).attributes }

  let(:invalid_attributes) {
    {
      frequency: 'this is not a frequency'
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RadiosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      radio = Radio.create! valid_attributes
      get :index, params: { shipment_id: shipment_id }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      radio = Radio.create! valid_attributes
      get :show, params: { shipment_id: shipment_id, id: radio.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do

      it "creates a new Radio" do
        expect {
          post :create, params: { shipment_id: shipment_id, radio: valid_attributes }, session: valid_session
        }.to change(Radio, :count).by(1)
      end

      it "that defaults to boxed: false" do
        radio = build(:base_radio)
        radio.shipment_id = shipment_id
        attributes = radio.attributes.except('frequency', 'boxed')

        expect {
          post :create, params: { radio: attributes }, session: valid_session
        }.to change(Radio, :count).by(1)

        expect(Radio.last.boxed).to be false
      end

      it "that records an assembly_date" do
        radio = build(:base_radio)
        radio.shipment_id = shipment_id
        attributes = radio.attributes.except('frequency', 'boxed')
        Timecop.freeze(Time.now)

        expect {
          post :create, params: { radio: attributes }, session: valid_session
        }.to change(Radio, :count).by(1)

        expect(Radio.last.assembly_date).to eq Date.today.to_s
      end

      it "renders a JSON response with the new radio" do
        post :create, params: { shipment_id: shipment_id, radio: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new radio" do

        post :create, params: { shipment_id: shipment_id, radio: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          frequency: '91.5'
        }
      }

      it "updates the requested radio" do
        radio = Radio.create! valid_attributes
        put :update, params: { id: radio.to_param, radio: new_attributes}, session: valid_session
        radio.reload
        expect(radio.frequency).to eq(new_attributes[:frequency])
      end

      it "renders a JSON response with the radio" do
        radio = Radio.create! valid_attributes

        put :update, params: { id: radio.to_param, radio: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with a shipment_id" do
      let(:radio) { create(:radio_assembled) }
      let(:shipped_shipment) { create(:label_created) }

      let(:new_attributes) {
        {
          shipment_id: shipped_shipment.id,
          boxed: true
        }
      }

      it "merges the radio with next unboxed radio in the shipment" do
        shipment = Shipment.find(shipped_shipment.id)
        next_unboxed_radio = shipment.next_unboxed_radio(shipped_shipment.id)
        put :update, params: { id: radio.to_param, radio: new_attributes}, session: valid_session

        expect{ radio.reload }.to change{ shipment.radio.where(frequency: next_unboxed_radio.serial_number) }.from(nil).to(radio.serial_number)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the radio" do
        radio = Radio.create! valid_attributes

        put :update, params: { shipment_id: shipment_id, id: radio.to_param, radio: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested radio" do
      radio = Radio.create! valid_attributes
      expect {
        delete :destroy, params: { shipment_id: shipment_id, id: radio.to_param}, session: valid_session
      }.to change(Radio, :count).by(-1)
    end
  end

end
