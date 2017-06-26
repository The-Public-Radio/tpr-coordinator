require 'rails_helper'

RSpec.describe "Radios", type: :request do
  describe "GET /radios" do
    it "works! (now write some real specs)" do
      get radios_path
      expect(response).to have_http_status(200)
    end
  end
end
