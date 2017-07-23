require 'rails_helper'

RSpec.describe "Radios", type: :request do
  let(:radio_model) { FactoryGirl.create(:radio) }
  let(:user_model) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in(user_model)
  end

  describe "GET /radios" do
    it "works! (now write some real specs)" do
      get radios_path
      expect(response).to have_http_status(204)
    end
  end
end
