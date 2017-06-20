require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'has an index endpoint that returns a 200' do
    get '/' do
      explanation 'the index of the application'
      example_request 'a call to the index endpoint' do
        expect(response_body).to be 'TPR Coordinator'
        expect(response_status).to be 200
      end
    end
  end
end
