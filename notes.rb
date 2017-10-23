{"messages"=>
  [{"text"=>
     "Please note that effective 11/1, it will no longer be possible to fetch live tracking data using the Shippo Test token. Please switch over to using your Shippo Live token in order to continue receiving live tracking data."}],
 "carrier"=>"usps",
 "tracking_number"=>"92055901755477000027174478",
 "address_from"=>{"city"=>"", "state"=>"", "zip"=>"", "country"=>"US"},
 "address_to"=>{"city"=>"Sag Harbor", "state"=>"NY", "zip"=>"11963", "country"=>"US"},
 "eta"=>"2017-10-06T00:00:00Z",
 "original_eta"=>"2017-10-05T00:00:00Z",
 "servicelevel"=>{"token"=>"usps_priority", "name"=>"Priority Mail"},
 "metadata"=>nil,
 "tracking_status"=>
  {"object_created"=>"2017-10-07T01:06:39.448Z",
   "object_updated"=>"2017-10-07T01:06:39.448Z",
   "object_id"=>"d7b6527393c9446f87472277df7c58c7",
   "status"=>"DELIVERED",
   "status_details"=>"Your shipment has been delivered at the front door.",
   "status_date"=>"2017-10-06T14:26:00Z",
   "location"=>{"city"=>"Sag Harbor", "state"=>"NY", "zip"=>"11963", "country"=>"US"}},
 "tracking_history"=>
  [{"object_created"=>"2017-09-14T03:51:50.799Z",
    "object_id"=>"754efe7c1e9146f7bf800c6b2c3559f7",
    "status"=>"UNKNOWN",
    "status_details"=>"Pre-Transit: Shipment information has been transmitted to the shipping carrier but it has not yet been scanned and picked up.",
    "status_date"=>nil,
    "location"=>nil},
   {"object_created"=>"2017-10-04T12:35:21.464Z",
    "object_id"=>"a4ed13b5fc7e401eb1f58991d880a7fc",
    "status"=>"UNKNOWN",
    "status_details"=>"The shipping label has been created and the USPS is awaiting the item.",
    "status_date"=>"2017-09-14T04:00:00Z",
    "location"=>{"city"=>"Elk Grove Village", "state"=>"IL", "zip"=>"60007", "country"=>"US"}
    }
  ]
}


r['tracking_status']['status']

t.get('92055901755477000027174478','usps')