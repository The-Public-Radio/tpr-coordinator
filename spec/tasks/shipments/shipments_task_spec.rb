require "rails_helper"

describe "shipments:check_shipment_status", type: :rake do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "calls the shippo API to check the tracking status of the shipment" do
   status_map = {
      'DELIVERED' => 'delivered',
      'TRANSIT' => 'transit',
      'FAILURE' => 'failure',
      'RETURNED' => 'returned'
    }
    shippo_response = JSON.parse(load_fixture('spec/fixtures/shippo_track_response.json'))

    status_map.each do |k,v|
      # create the shipments we need to test:
      shipments = create_list(:boxed, 2)
      # These shipments should not be checked
      create(:label_printed)
      create(:shipped)
      # Set up tracking status
      shippo_response['tracking_status']['status'] = k

      # Mock the shippo call
      expect(Shippo::Track).to receive(:get).with(shipments[0].tracking_number, 'usps').and_return(shippo_response).exactly(6).times
      expect(Shippo::Track).to receive(:get).with(shipments[1].tracking_number, 'usps').and_return(shippo_response) 

      task.execute

      shipments.each do |shipment|
        # Check the change
        expect{ shipment.reload }.to change{ shipment.shipment_status }.from('boxed').to(v)
      end
    end
  end
end