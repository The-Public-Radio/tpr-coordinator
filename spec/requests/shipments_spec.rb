require 'rails_helper'

RSpec.describe "Shipments", type: :request do
  describe "GET /shipments" do
    it "works! (now write some real specs)" do
      get shipments_path
      expect(response).to have_http_status(204)
    end
  end
end
