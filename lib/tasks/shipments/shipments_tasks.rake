namespace :shipments do
  desc "TODO"
  task check_shipment_status: :environment do
  	# Find all shipments that are boxed in batches
  	# TODO refactor to use .find_in_batches(batch_size: 100)
  	boxed_shipments = Shipment.where(shipment_status: 'boxed') 

  	boxed_shipments.each do |shipment|
  		Rails.logger.info("Checking tracking status for shipment #{shipment.id} ")
			# Check tracking status
			tracking_status = Shippo::Track.get(shipment.tracking_number, 'usps')['tracking_status']['status']
			# Update shipment status
			status_whitelist = %w{DELIVERED TRANSIT FAILURE RETURNED}
			if status_whitelist.include?(tracking_status)
				Rails.logger.info("Updating shipment_status for shipment #{shipment.id}")
				shipment.shipment_status = tracking_status.downcase
				shipment.save
			else
				Rails.logger.error("Tracking status did not match #{status_whitelist}: #{tracking_status}")
			end
  	end
  end
end