require 'rails_helper'
# require 'helpers/shippo_helper'

RSpec.describe ShippoHelper, type: :helper do
    context 'with the shippo_api' do
        # Shipment creation params
        let(:shipment) { create(:created) }
        let(:order) { Order.find(shipment.order_id) }

        let(:create_shipment_params)  { 
            {
                address_return: return_address,
                address_from: from_address,
                address_to: to_address,
                parcels: one_radio_parcel,
                carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"]              
            } 
        }

        let(:create_international_shipment_params) do
            create_shipment_params[:customs_declaration] = customs_declaration_object
            create_shipment_params
        end

        let(:create_shipment_with_return_params) do
            {
                address_from: warranty_return_address,
                address_to: to_address,
                parcels: one_radio_parcel,
                carrier_accounts: ["d2ed2a63bef746218a32e15450ece9d9"],
                extra: { is_return: true }
            } 
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
                :value_amount => "15",
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
                :value_amount => "30",
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
                :value_amount => "45",
                :value_currency => "USD",
                :origin_country => "US"
            }
        }
        
        let(:return_address) {
            {
                :name => 'Centerline Labs',
                :company => '',
                :street1 => '544 Park Ave',
                :street2 => 'Ste 332',
                :city => 'Brooklyn',
                :state => 'NY',
                :zip => '11205',
                :country => 'US',
                :phone => '123-456-7890',
                :email => 'info@thepublicrad.io'
              }
        }

        let(:from_address) {
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
        }

        let(:warranty_return_address) {
            {
                :name => 'Centerline Labs',
                :company => '',
                :street1 => '544 Park Ave',
                :street2 => 'Ste 332',
                :city => 'Brooklyn',
                :state => 'NY',
                :zip => '11205',
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
        let(:shippo_shipment) { double('shippo_shipment', "status": "QUEUED", "object_id": "test_object_id",
            "rates": [{"object_id": "test_rate_id", "servicelevel": { "token": "usps_priority" }}, 
            {"object_id": "test_rate_id2", "servicelevel": { "token": "usps_first_priority" }}
            ])
        }
        
        let(:success_shippo_shipment) { double('success_shippo_shipment', "status": "SUCCESS",)
        }

        let(:failed_shippo_shipment) { double('failed_shippo_shipment', "status": "FAILURE", "messages": 'this is a test error message')
        }

        # This is separate from the above due to the rates needing to be different in future testing.
        let(:shippo_shipment_with_return) { double('shippo_shipment_with_return', "status": "SUCCESS", "rates": [])}     

        let(:shippo_transaction) { double('shippo_transaction', "status": "SUCCESS", "tracking_number": "test_tracking_number", "label_url": "test_label_url")}

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

                it 'return' do
                    expect(ShippoHelper.return_address).to eq return_address
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
                    expect(Shippo::CustomsDeclaration).to receive(:create).with(customs_declaration_options).and_return(customs_declaration_object)
                    expect(ShippoHelper.customs_declaration(1)).to be customs_declaration_object
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
            def successful_shipment_creation_mock
                expect(shippo_shipment).to receive(:[]).with("status").and_return("QUEUED").once
                expect(shippo_shipment).to receive(:[]).with("object_id").and_return("test_object_id").once
                expect(Shippo::Shipment).to receive(:get).with("test_object_id").and_return(success_shippo_shipment).at_least(1).times
                expect(success_shippo_shipment).to receive(:[]).with("status").and_return("SUCCESS").exactly(3).times
                expect(shippo_shipment).to receive(:label_url).and_return(nil).once
            end
            
            it 'creates a shipment' do
                successful_shipment_creation_mock
                expect(Shippo::Shipment).to receive(:create).with(create_shipment_params).and_return(shippo_shipment).once
                expect(ShippoHelper.create_shipment(shipment)).to be (success_shippo_shipment)
            end

            it 'creates a international shipment' do
                successful_shipment_creation_mock
                expect(Shippo::CustomsDeclaration).to receive(:create).with(customs_declaration_options).and_return(customs_declaration_object)
                expect(Shippo::Shipment).to receive(:create).with(create_international_shipment_params).and_return(shippo_shipment).once            
                expect(ShippoHelper.create_international_shipment(shipment)).to be (success_shippo_shipment)
            end

            it 'handles a create shipment failure' do
                expect(failed_shippo_shipment).to receive(:[]).with("status").and_return("FAILURE")
                expect(Shippo::Shipment).to receive(:create).with(create_shipment_params).and_return(failed_shippo_shipment).once            
                expect{ ShippoHelper.create_shipment(shipment) }.to raise_error(ShippoHelper::ShippoError)
            end

            it 'handles a create shipment failure' do
                expect(shippo_shipment).to receive(:[]).with("status").and_return("SUCCESS")
                expect(Shippo::Shipment).to receive(:create).with(create_shipment_params).and_return(shippo_shipment).once            
                expect{ ShippoHelper.create_shipment(shipment) }.to_not raise_error(ShippoHelper::ShippoError)
            end

            it 'creates a shipment with a return label' do
                successful_shipment_creation_mock
                expect(Shippo::Shipment).to receive(:create).with(create_shipment_with_return_params).and_return(shippo_shipment).once            
                # Make sure the shipment object is returned
                expect(ShippoHelper.create_shipment_with_return(shipment)).to be success_shippo_shipment
            end

            skip 'creates a transaction to make a label' do
                test_shipment = create(:created)
                test_shipment.rate_reference_id = 'test_rate_id'
                test_shipment.save

                expect(success_shippo_shipment).to receive(:[]).with("status").and_return("SUCCESS")
                expect(Shippo::Transaction).to receive(:create).with(create_transaction_params).and_return(shippo_transaction)
                expect(Shippo::Transaction).to receive(:get).with(shippo_shipment.object_id).and_return(success_shippo_shipment)
                expect(shippo_transaction).to receive(:[]).with("status").and_return("QUEUED").ordered
                expect(shippo_transaction).to receive(:[]).with("object_id").and_return("test_object_id").ordered
                expect(shippo_transaction).to receive(:[]).with("status").and_return("SUCCESS").ordered
                expect(ShippoHelper.create_label(test_shipment)).to be shippo_transaction
            end

            it 'chooses a rate' do
                expect(ShippoHelper.choose_rate(shippo_shipment.rates, "usps_priority")).to eq('test_rate_id')
            end
        end
    end
end
