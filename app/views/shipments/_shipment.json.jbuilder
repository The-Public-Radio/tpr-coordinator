json.extract! shipment, :id, :tracking_number, :ship_date, :status, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)
