require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
    get '/' do
    explanation 'the index of the application'
    example_request 'what is this' do
      expect(response_body).to be 'TPR Coordinator'
    end
  end
end
