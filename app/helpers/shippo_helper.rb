require 'shippo'

module ShippoHelper
    class ShippoError < StandardError
    end

    # Module functions:
    # - create_shipment
    # - create_international_shipment
    # - create_shipment_with_return
    # - create_label
    # - choose_rate

    def self.parcel(number_of_items)
        if number_of_items == 2
            {
              :length => 6,
              :width => 5,
              :height => 4,
              :distance_unit => :in,
              :weight => 1.75,
              :mass_unit => :lb
            }
        elsif number_of_items == 3
            {
              :length => 9,
              :width => 5,
              :height => 4,
              :distance_unit => :in,
              :weight => 2.60,
              :mass_unit => :lb
            }
        else
            {
              :length => 5,
              :width => 4,
              :height => 3,
              :distance_unit => :in,
              :weight => 12,
              :mass_unit => :oz
            }
        end
    end

    def self.customs_item(number_of_items)
        if number_of_items == 1
            {
              :description => "Single station FM radio",
              :quantity => 1,
              :net_weight => "12",
              :mass_unit => "oz",
              :value_amount => "15",
              :value_currency => "USD",
              :origin_country => "US"
            }
          elsif number_of_items == 2
            {
              :description => "Single station FM radio",
              :quantity => 2,
              :net_weight => "1.75",
              :mass_unit => "lb",
              :value_amount => "30",
              :value_currency => "USD",
              :origin_country => "US"
            }
          elsif number_of_items == 3
            {
              :description => "Single station FM radio",
              :quantity => 3,
              :net_weight => "2.60",
              :mass_unit => "lb",
              :value_amount => "45",
              :value_currency => "USD",
              :origin_country => "US"
            }
        end
    end

    def self.customs_declaration(number_of_items)
        customs_declaration_options = {
            :contents_type => "MERCHANDISE",
            :contents_explanation => "Single station FM radio",
            :non_delivery_option => "ABANDON",
            :certify => true,
            :certify_signer => "Spencer Wright",
            :items => [customs_item(number_of_items)]
        }
        Rails.logger.debug("Creating Customs Declaration with options: #{customs_declaration_options}")
        begin
            Shippo::API.token = ENV['SHIPPO_TOKEN']
            response = Shippo::CustomsDeclaration.create(customs_declaration_options)
        rescue Shippo::Exceptions => e
            Rails.logger.error("Creating Customs Declaration failed! #{response}")
            raise ShippoError.new(response["messages"])
        end
        response
    end

    def self.create_shipment_params(shipment)
        order = Order.find(shipment.order_id)
        number_of_items = shipment.radio.count
        {
            address_from: from_address,
            address_return: return_address,
            address_to: to_address(order),
            parcels: parcel(number_of_items),
            carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"]
        }
    end

    def self.create_warranty_shipment_params(shipment)
        order = Order.find(shipment.order_id)
        number_of_items = shipment.radio.count
        {
            address_from: warranty_return_address,
            address_to: to_address(order),
            parcels: parcel(number_of_items),
            carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"]
        }
    end

    def self.create_international_shipment_params(shipment)
        order = Order.find(shipment.order_id)
        number_of_items = shipment.radio.count
        {
            address_from: from_address,
            address_return: return_address,
            address_to: to_address(order),
            parcels: parcel(number_of_items),
            carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"],
            customs_declaration: customs_declaration(number_of_items)
        }
    end

    def self.create_international_warranty_shipment_params(shipment)
        order = Order.find(shipment.order_id)
        number_of_items = shipment.radio.count
        {
            address_from: warranty_return_address,
            address_to: to_address(order),
            parcels: parcel(number_of_items),
            carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"],
            customs_declaration: customs_declaration(number_of_items)
        }
    end

    def self.to_address(order)
        {
          :name => order.name,
          :company => '',
          :street1 => order.street_address_1,
          :street2 => order.street_address_2,
          :city => order.city,
          :state => order.state,
          :zip => order.postal_code,
          :country => order.country,
          :phone => order.phone.nil? ? '' : order.phone,
          :email => order.email
        }
    end

    def self.return_address
        # Send back for non-deliveries
        {
          :name => 'Centerline Labs',
          :company => '',
          :street1 => '544 Park Ave',
          :street2 => 'Ste 332',
          :city => 'Brooklyn',
          :state => 'NY',
          :zip => '11205',
          :country => 'US',
          :phone => ENV['FROM_ADDRESS_PHONE_NUMBER'],
          :email => 'info@thepublicrad.io'
        }
    end

    def self.from_address
        # Shipment processing facilities
        {
          :name => 'Centerline Labs',
          :company => '',
          :street1 => '544 Park Ave',
          :street2 => 'Ste 332',
          :city => 'Brooklyn',
          :state => 'NY',
          :zip => '11205',
          :country => 'US',
          :phone => ENV['FROM_ADDRESS_PHONE_NUMBER'],
          :email => 'info@thepublicrad.io'
        }
    end

    def self.warranty_return_address
        {
          :name => 'Centerline Labs',
          :company => '',
          :street1 => '544 Park Ave',
          :street2 => 'Ste 332',
          :city => 'Brooklyn',
          :state => 'NY',
          :zip => '11205',
          :country => 'US',
          :phone => ENV['FROM_ADDRESS_PHONE_NUMBER'],
          :email => 'info@thepublicrad.io'
        }
    end

    def self.create_international_shipment(shipment)
        shipment_params = create_international_shipment_params(shipment)
        create_shippo_shipment(shipment_params)
    end

    def self.create_shipment(shipment)
        shipment_params = create_shipment_params(shipment)
        create_shippo_shipment(shipment_params)
    end

    def self.create_shipment_with_return(shipment)
        shipment_params = create_warranty_shipment_params(shipment)
        shipment_params[:extra] = { is_return: true }
        create_shippo_shipment(shipment_params)
    end

    def self.create_international_shipment_with_return(shipment)
        shipment_params = create_international_warranty_shipment_params(shipment)
        shipment_params[:extra] = { is_return: true }
        create_shippo_shipment(shipment_params)
    end

    def self.create_shippo_shipment(shipment_params)
        Rails.logger.debug("Shipment create options: #{shipment_params}")
        Shippo::API.token = ENV['SHIPPO_TOKEN']
        response = Shippo::Shipment.create(shipment_params)
        wait_for_shipoo_queue(response)
    end

    def self.choose_rate(shippo_rates, service_level)
        # Choose the rate which maps to a shipment's priority
        choosen_rate = ''
        shippo_rates.select do |rate|
            if rate[:servicelevel][:token] == service_level
                choosen_rate = rate
            end
        end

        Rails.logger.debug('*' * 50)
        Rails.logger.debug("SERVICE LEVEL: #{service_level}")
        Rails.logger.debug(shippo_rates.inspect)
        Rails.logger.debug('*' * 50)

        choosen_rate[:object_id]
    end

    def self.create_label(shipment)
        rate_id = shipment.rate_reference_id
        Rails.logger.debug("Creating Shippo label for shipment #{shipment.id} with rate #{rate_id}")
        Shippo::API.token = ENV['SHIPPO_TOKEN']
        response = Shippo::Transaction.create(rate: rate_id)
        wait_for_shipoo_queue(response)
    end

    def self.wait_for_shipoo_queue(response)
        # Check response for error
        Rails.logger.debug("Shippo response: #{response}")
        status = response["status"]
        Rails.logger.debug("Shippo status: #{status}")

        # Check if the shipment has already succeeded
        if status == "SUCCESS"
            return response
        end

        if status != "QUEUED"
            Rails.logger.error("Response status is #{status} not QUEUED or SUCCESS. Something went wrong with Shippo shipment creation")
            Rails.logger.error(response)
            raise ShippoError.new(response["messages"][0]["text"])
        end
        # Wait for the shipment or transation to be processed by shippo
        shippo_resource_id = response["object_id"]
        # Max retry count waiting for a successfully rate allotment
        # 1 * 30 = 60 seconds
        shippo_max_retry_count = 60
        shippo_retry_count = 0
        Rails.logger.debug("Waiting for to move out of queue. Shippo object_id: #{shippo_resource_id}")
        # This is bad and really syncronous but works
        # TODO: make label on get_next_shipment
        while status == "QUEUED"
            # retry counter
            Rails.logger.debug("Checking status in Shippo. Retry count: #{shippo_retry_count}")
            if shippo_retry_count > shippo_max_retry_count
                break
            else
                shippo_retry_count += 1
            end
            Rails.logger.debug("Waiting for Shippo resource to move out of queue")
            sleep(1)
            # TODO: Find a better way of checking if this is a shipment or transaction response
            if response.label_url.nil?
                response = Shippo::Shipment.get(shippo_resource_id)
                Rails.logger.debug("Shippo Shipment get response for #{shippo_resource_id}: #{response}")
            else
                response = Shippo::Transaction.get(shippo_resource_id)
                Rails.logger.debug("Shippo Transaction get response for #{shippo_resource_id}: #{response}")
            end
            status = response["status"]
        end
        # Check response status again to make sure it completed succesfully and did not error
        Rails.logger.debug("Checking shippo response for error. Status: #{response["status"]}")
        Rails.logger.debug("Shippo response: #{response}")
        if response["status"] != "SUCCESS"
            Rails.logger.error(response)
            raise ShippoError.new(response["messages"][0]["text"])
        end
        response
    end
end
