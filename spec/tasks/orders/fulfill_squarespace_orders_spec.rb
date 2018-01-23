require "rails_helper"

describe "orders:fulfill_squarespace_orders", type: :rake do

    it "preloads the Rails environment" do
      expect(task.prerequisites).to include "environment"
    end

    it 'fulfills all boxed squarespace orders that have not been notified and are shipped' do
        api_key = ENV['SQUARESPACE_API_KEY']
        app_name = ENV['SQUARESPACE_APP_NAME']

        orders_to_notify = create_list(:squarespace, 2)
        create_list(:squarespace_order_notified, 1)

        stub_client = instance_double(Squarespace::Client, :fulfill_order)
        expect(Squarespace::Client).to receive(:new).with(app_name: app_name, api_key: api_key)
            .and_return(stub_client)

        stub_response = double('response', success?: true)

        orders_to_notify.each do |order|
            id, order_number = order[:reference_number].split(',')

            shipments = []
            order.shipments.each do |shipment|
            shipments << {
                tracking_number: shipment[:tracking_number],
                tracking_url: "https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=#{shipment['tracking_number']}",
                carrier_name: 'USPS',
                service: shipment[:shipment_priority]
            }
            end
            expect(stub_client).to receive(:fulfill_order).with(id, shipments, true).and_return(stub_response)
        end

        task.execute
    end
end