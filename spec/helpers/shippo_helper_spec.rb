require 'rails_helper'

RSpec.describe ShippoHelper, type: :helper do
    context 'with the shippo_api' do
        # Order
        let(:order) { create(:order) }

        # Shipment creation params
        let(:shipment) { create(:created) }
        
        let(:create_shipment_params)  { 
            {
                address_from: {
                    :name => 'Centerline Labs',
                    :company => '',
                    :street1 => '814 Lincoln Pl',
                    :street2 => '#2',
                    :city => 'Brooklyn',
                    :state => 'NY',
                    :zip => '11216',
                    :country => 'US',
                    :phone => '123-456-7890',
                    :email => 'info@thepublicrad.io'
                },
                address_to: {
                    :name => order.name,
                    :company => '',
                    :street1 => '123 West 9th St.',
                    :street2 => 'Apt 4',
                    :city => 'Brooklyn',
                    :state => 'NY',
                    :zip => '11221',
                    :country => 'US',
                    :phone => '123-321-1231',
                    :email => order.email
                },
                parcels: {
                    :length => 5,
                    :width => 4,
                    :height => 3,
                    :distance_unit => :in,
                    :weight => 12,
                    :mass_unit => :oz
                },
                carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"]              
            } 
        }

        let(:create_international_shipment_params) do
            create_shipment_params[:customs_declaration] = customs_declaration_object
            create_shipment_params
        end

        let(:create_shipment_with_return_params) do
            create_shipment_params[:extra] = { is_return: true }
            create_shipment_params
        end
  
        let(:create_transaction_params)  { {
                :rate => "test_rate_id"
            }
        }

        # Parcel types
        let(:one_radio_parcel) {
            {
                :length => 5,
                :width => 4,
                :height => 3,
                :distance_unit => :in,
                :weight => 12,
                :mass_unit => :oz
              }
        }

        let(:two_radio_parcel) {
            {
                :length => 6,
                :width => 5,
                :height => 4,
                :distance_unit => :in,
                :weight => 1.75,
                :mass_unit => :lb
            }
        }

        let(:three_radio_parcel) {
            {
                :length => 9,
                :width => 5,
                :height => 4,
                :distance_unit => :in,
                :weight => 2.60,
                :mass_unit => :lb
            }
        }

        # Customs declaration types

        let(:one_radio_customs_item) {
            {
                :description => "Single station FM radio",
                :quantity => 1,
                :net_weight => "12",
                :mass_unit => "oz",
                :value_amount => "40",
                :value_currency => "USD",
                :origin_country => "US"
            }
        }  
        
        let(:two_radio_customs_item) {
            {
                :description => "Single station FM radio",
                :quantity => 2,
                :net_weight => "1.75",
                :mass_unit => "lb",
                :value_amount => "80",
                :value_currency => "USD",
                :origin_country => "US"
            }
        }  

        let(:three_radio_customs_item) {
            {
                :description => "Single station FM radio",
                :quantity => 3,
                :net_weight => "2.60",
                :mass_unit => "lb",
                :value_amount => "120",
                :value_currency => "USD",
                :origin_country => "US"
            }
        }
        
        let(:from_address) {
            {
                :name => 'Centerline Labs',
                :company => '',
                :street1 => '814 Lincoln Pl',
                :street2 => '#2',
                :city => 'Brooklyn',
                :state => 'NY',
                :zip => '11216',
                :country => 'US',
                :phone => '123-456-7890',
                :email => 'info@thepublicrad.io'
              }
        }

        let(:warranty_return_address) {
            {
                :name => 'Centerline Labs',
                :company => '',
                :street1 => '814 Lincoln Pl',
                :street2 => '#2',
                :city => 'Brooklyn',
                :state => 'NY',
                :zip => '11216',
                :country => 'US',
                :phone => '123-456-7890',
                :email => 'info@thepublicrad.io'
            }
        }

        let(:to_address) {
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
        }

        let(:customs_declaration_options) {
            {
                :contents_type => "MERCHANDISE",
                :contents_explanation => "Single station FM radio",
                :non_delivery_option => "ABANDON",
                :certify => true,
                :certify_signer => "Spencer Wright",
                :items => [one_radio_customs_item]
            }
        }
        
        let(:customs_declaration_object) { double(Shippo::CustomsDeclaration) }

        # Shippo API doubles
        let(:shippo_shipment) { double('shippo_shipment', status: "SUCCESS", rates: [])}

        # This is separate from the above due to the rates needing to be different in future testing.
        let(:shippo_shipment_with_return) { double('shippo_shipment', status: "SUCCESS", rates: [])}        

        describe 'setting up a shipment' do
            it 'creates shipping parameters from a Shipment object' do
                expect(ShippoHelper.create_shipment_params(shipment)).to eq create_shipment_params
            end

            it 'creates international shipping parameters from a Shipment object' do
                expect(Shippo::CustomsDeclaration).to receive(:create).and_return(customs_declaration_object)
                expect(ShippoHelper.create_international_shipment_params(shipment)).to eq create_international_shipment_params
            end

            describe 'addresses' do
                it 'from' do
                    expect(ShippoHelper.from_address).to eq from_address
                end

                it 'warranty return' do 
                    expect(ShippoHelper.warranty_return_address).to eq warranty_return_address
                    
                end

                it 'to built from order params' do
                    expect(ShippoHelper.to_address(order)).to eq to_address
                end
            end

            describe 'and paracel' do
                it 'for 1 radio' do
                    expect(ShippoHelper.parcel(1)).to eq one_radio_parcel
                end

                it 'for 2 radios' do
                    expect(ShippoHelper.parcel(2)).to eq two_radio_parcel
                end

                it 'for 3 radios' do
                    expect(ShippoHelper.parcel(3)).to eq three_radio_parcel
                end
            end

            describe 'and customs declaration' do
                it 'creates a customs declaration' do
                    shippo_customs_declaration_object = double("shippo_customs_declaration")

                    expect(Shippo::CustomsDeclaration).to receive(:create).with(customs_declaration_options).and_return(shippo_customs_declaration_object)
                    expect(ShippoHelper.customs_declaration(1)).to be shippo_customs_declaration_object
                end

                it 'creates a customs item for 1 radio' do
                    expect(ShippoHelper.customs_item(1)).to eq one_radio_customs_item
                end

                it 'creates a customs item for 2 radio' do
                    expect(ShippoHelper.customs_item(2)).to eq two_radio_customs_item
                end

                it 'creates a customs item for 3 radio' do
                    expect(ShippoHelper.customs_item(3)).to eq three_radio_customs_item
                end
            end
        end

        describe 'api operations' do
            it 'creates a shipment' do
                expect(Shippo::Shipment).to receive(:create).with(create_shipment_params).and_return(shippo_shipment).once            
                expect(ShippoHelper.create_shipment(shipment)).to be (shippo_shipment)
            end

            it 'creates a shipment with a return label' do
                # Create shipment
                expect(Shippo::Shipment).to receive(:create).with(create_shipment_with_return_params).and_return(shippo_shipment_with_return).once            
                
                # Make sure the shipment object is returned
                expect(ShippoHelper.create_shipment_with_return(shipment)).to be (shippo_shipment_with_return)
            end

            it 'creates a transaction to make a label' do
                skip("todo")
            end

            it 'chooses a rate' do
                shipment.rate_reference_id = 'test_shippo_rate_reference_id'
                shipment.save
                expect(ShippoHelper.choose_rate(shippo_rates)).to eq('test_rate_id')
            end
        end
    end
end