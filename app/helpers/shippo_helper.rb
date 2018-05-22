require 'shippo'

module ShippoHelper
    class ShippoError < StandardError
    end

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
              :value_amount => "40",
              :value_currency => "USD",
              :origin_country => "US"
            }
          elsif number_of_items == 2
            {
              :description => "Single station FM radio",
              :quantity => 2,
              :net_weight => "1.75",
              :mass_unit => "lb",
              :value_amount => "80",
              :value_currency => "USD",
              :origin_country => "US"
            }
          elsif number_of_items == 3
            {
              :description => "Single station FM radio",
              :quantity => 3,
              :net_weight => "2.60",
              :mass_unit => "lb",
              :value_amount => "120",
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
    
        Shippo::CustomsDeclaration.create(customs_declaration_options)
    end

    def self.create_shipment_params(shipment)
        order = Order.find(shipment.order_id)
        number_of_items = shipment.radio.count
        {
            address_from: from_address,
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
  
    def self.from_address
        {
          :name => 'Centerline Labs',
          :company => '',
          :street1 => '814 Lincoln Pl',
          :street2 => '#2',
          :city => 'Brooklyn',
          :state => 'NY',
          :zip => '11216',
          :country => 'US',
          :phone => ENV['FROM_ADDRESS_PHONE_NUMBER'],
          :email => 'info@thepublicrad.io'
        }
    end

    def self.warranty_return_address
        {
            :name => 'Centerline Labs',
            :company => '',
            :street1 => '814 Lincoln Pl',
            :street2 => '#2',
            :city => 'Brooklyn',
            :state => 'NY',
            :zip => '11216',
            :country => 'US',
            :phone => ENV['FROM_ADDRESS_PHONE_NUMBER'],
            :email => 'info@thepublicrad.io'
        }
    end

    def self.create_shipment(shipment)
        shipment_params = create_shipment_params(shipment)
        create_shippo_shipment(shipment_params)
    end

    def self.create_shipment_with_return(shipment)   
        shipment_params = create_shipment_params(shipment)
        shipment_params[:extra] = { is_return: true }
        create_shippo_shipment(shipment_params)
    end

    def self.create_shippo_shipment(shipment_params)
        Rails.logger.debug("Shipment create options: #{shipment_params}")    
        Shippo::API.token = ENV['SHIPPO_TOKEN']            
        response = Shippo::Shipment.create(shipment_params)
        if response["status"] != "SUCCESS"
            Rails.logger.error(response.messages)
            raise ShippoError.new(response.messages)
        end
        response
    end

    def self.choose_rate(shippo_rates, service_level)
        # Choose the rate which maps to a shipment's priority
        choosen_rate = ''        
        shippo_rates.select do |rate|
            if rate[:servicelevel][:token] == service_level
                choosen_rate = rate
            end
        end
        choosen_rate[:reference_id]
    end

    def self.create_label(shipment)
        rate_id = shipment.rate_reference_id
        Shippo::API.token = ENV['SHIPPO_TOKEN']
        transaction = Shippo::Transaction.create(rate: rate_id)
    end
end