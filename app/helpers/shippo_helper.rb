require 'shippo'

module ShippoHelper
    attr_reader :shippo_client
    
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

    def self.setup_create_shipment_params(shipment)

    end
end