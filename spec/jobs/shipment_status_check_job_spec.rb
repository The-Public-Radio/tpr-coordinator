require 'rails_helper'

RSpec.describe ShipmentStatusCheckJob, type: :job do
	describe "#perform" do
    it "uploads a backup" do
      ActiveJob::Base.queue_adapter = :test
      ShipmentStatusCheckJob.perform_later('check_status')
      expect(ShipmentStatusCheckJob).to have_been_enqueued.exactly(:once)
    end
  end

  describe "#check_status" do
  	it "calls the shippo api to check the status of each shipment" do
	  	skip('write this')
	  end
	  
	  it "updates the shipment_status to delivered if the package has been delivered" do
	  	skip('write this')
	  end

	  it "updates the shipment_status to shipped if usps has the package" do
	  	skip('write this')
	  end

	  it "updates the shipment_status to label_created for shipments that are not in transit" do
	  	skip('write this')
	  end
  end
end
