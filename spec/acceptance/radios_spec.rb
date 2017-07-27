require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Radios" do
  before do
    header "Authorization", "Bearer myaccesstoken"
  end

  fixtures :radios

  get "/radios/:id" do
    header('Content-Type', 'application/json')
    let(:id) { 1 }
    example "Looking up a single radio" do
      do_request
      expect(status).to eq 200
      data = JSON.parse(response_body)['data']
      expect(data['frequency']).to eq('90.5')
    end
  end
end
