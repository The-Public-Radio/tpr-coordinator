require "rails_helper"

describe "orders:fulfill_squarespace_orders", type: :rake do

    it "preloads the Rails environment" do
      expect(task.prerequisites).to include "environment"
    end

    it 'fulfills all boxed squarespace orders that have not been notified' do
        skip('todo')
        api_key = ENV['SQUARESPACE_API_KEY']
        app_name = ENV['SQUARESPACE_APP_NAME']

        stub_client = instance_double(Squarespace::Client, :get_orders)
        expect(Squarespace::Client).to receive(:new).with(app_name: app_name, api_key: api_key)
            .and_return(stub_client)
        task.execute
    end
end