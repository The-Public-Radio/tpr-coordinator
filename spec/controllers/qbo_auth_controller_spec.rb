require 'rails_helper'

RSpec.describe QboAuthController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.body).to match /<html>/im
    end
  end

  describe "GET #callback" do
    # no tests for this, since it calls external resources that are a pain to stub out.
  end

end
