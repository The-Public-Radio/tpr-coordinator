#!/bin/usr/env ruby
# Run this from a Rails console on Heroku
 

# Delete assembled radio

Radio.where(serial_number: 'TPRv2.0_1_49432').delete.save

# Update radio to not be boxed
r = Radio.find(36)
r.boxed = false
r.save

# Update shipment to not be boxed
s = Shipment.find(25)
s.boxed = false
s.save
