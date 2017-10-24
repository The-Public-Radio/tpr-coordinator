describe "rake shipments:check_shipment_status", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "calls the shippo API to check the tracking status of the shipment" do
   status_map = {
      'UNKNOWN' => 'unknown',
      'DELIVERED' => 'delivered',
      'TRANSIT' => 'transit',
      'FAILURE' => 'failure',
      'RETURNED' => 'returned'
    }
    shippo_response = JSON.parse('spec/fixtures/shippo_track_response.json')

    status_map.each do |k,v|
      # create the shipments we need to test:
      shipment = create(:boxed)
      # These shipments should not be checked
      create(:label_printed)
      create(:shipped)
      # Set up tracking number and tracking status
      tracking_number = shipment.tracking_number 
      shippo_response['tracking_status']['status'] = k
      # Mock the shippo call
      expect(Shippo::Track).to receive(:get).with(tracking_number, 'usps').and_return(shippo_response).once
      # Check the change
      expect{ task.execute }.to change{ shipment.shipment_status }.from(k).to(v)
    end
  end
end