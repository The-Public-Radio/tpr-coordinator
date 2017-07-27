require 'rails_helper'

RSpec.describe "Shipments", type: :request do
  describe "GET /shipments" do
    it "works! (now write some real specs)" do
      get shipments_path
      expect(response).to have_http_status(204)
    end

    it "returns the number of radios in a given shipment" do
      params = {
        tracking: '9374889691090496006367'
      }
      response_body = {
        id: 1,
        number_of_radios: 4
      }

      get shipments_path, params: { :shipment => params }
      expect(response).to have_http_status(200)
      expect(response).to have_body(response_body)
      expect(response.content_type).to eq "application/json"
    end

    # it "returns the nth number radio in a given shipment" do
    #   params = {
    #     tracking: '9374889691090496006367'
    #   }
    #   response_body = {
    #     shipment: {
    #       id: 1,
    #       radio_number: 1,
    #       radio: {
    #         id: 1,
    #         frequency: '90.5'
    #       }
    #     }
    #   }

    #   get shipments_path, params: { :shipment => params }
    #   expect(response).to have_http_status(200)
    #   expect(response).to have_body(response_body)
    #   expect(response.content_type).to eq "application/json"
    # end
  end
end
