require 'rails_helper'

RSpec.describe MonitoringController, type: :controller do
  describe "GET #health" do
    it "returns a success response" do
      get :health
      expect(response).to be_success
    end
  end
end
