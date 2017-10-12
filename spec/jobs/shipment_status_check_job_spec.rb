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
  	# 'UNKNOWN', 'DELIVERED', 'TRANSIT', 'FAILURE', 'RETURNED'.
  	let(:shippo_not_shipped_response) { 
  		{
			    "object_state":"VALID",
			    "status":"SUCCESS",
			    "object_created":"2014-11-29T16:31:19.512Z",
			    "object_updated":"2014-11-29T16:31:19.512Z",
			    "object_id":"5695ae3a5eda41ba9abdbf347fd545f3",
			    "tracking_number":"9102969010383081813033",
			    "tracking_status":{  
			        "object_created":"2014-11-29T16:31:19.511Z",
			        "status":"UNKNOWN",
			        "status_details":"Your shipment has been delivered.",
			        "status_date":"2012-03-08T09:58:00Z",
			        "location":{  
			            "city":"Beverly Hills",
			            "state":"CA",
			            "zip":"90210",
			            "country":"US"
			        }
			    },
			    "eta":"2014-07-21T12:00:00.000Z"
			}
  	 }

  	let(:shippo_delivered_response) {
  		{
			    "object_state":"VALID",
			    "status":"SUCCESS",
			    "object_created":"2014-11-29T16:31:19.512Z",
			    "object_updated":"2014-11-29T16:31:19.512Z",
			    "object_id":"5695ae3a5eda41ba9abdbf347fd545f3",
			    "tracking_number":"9102969010383081813033",
			    "tracking_status":{  
			        "object_created":"2014-11-29T16:31:19.511Z",
			        "status":"DELIVERED",
			        "status_details":"Your shipment has been delivered.",
			        "status_date":"2012-03-08T09:58:00Z",
			        "location":{  
			            "city":"Beverly Hills",
			            "state":"CA",
			            "zip":"90210",
			            "country":"US"
			        }
			    },
			    "eta":"2014-07-21T12:00:00.000Z"
			}
  	}

  	let(:shippo_picked_up_response) {
  		{
			    "object_state":"VALID",
			    "status":"SUCCESS",
			    "object_created":"2014-11-29T16:31:19.512Z",
			    "object_updated":"2014-11-29T16:31:19.512Z",
			    "object_id":"5695ae3a5eda41ba9abdbf347fd545f3",
			    "tracking_number":"9102969010383081813033",
			    "tracking_status":{  
			        "object_created":"2014-11-29T16:31:19.511Z",
			        "status":"TRANSIT",
			        "status_details":"Your shipment has been delivered.",
			        "status_date":"2012-03-08T09:58:00Z",
			        "location":{  
			            "city":"Beverly Hills",
			            "state":"CA",
			            "zip":"90210",
			            "country":"US"
			        }
			    },
			    "eta":"2014-07-21T12:00:00.000Z"
			}
  	}

  	let(:shippo_transactions_url) { 'https://api.goshippo.com/transactions/' }
  	let(:shippo_headers) { 'HEADERS' }
  	it "calls the shippo api to check the status of each shipment" do
	  	
	  	shippo_params = {

	  	}
	  	
	  	expect(HTTParty).to recieve(:get).with(shippo_transactions_url, shippo params).and_return
	  	ShipmentStatusCheckJob.check_status
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
