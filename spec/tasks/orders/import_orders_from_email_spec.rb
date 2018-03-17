require "rails_helper"
require "shipments_controller"

describe "orders:import_orders_from_email", type: :rake do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  context 'from the tprorder@gmail.com gmail account' do
    # Stub attachment
    let(:stub_attachment) { double('attachment', decode: generic_order_fixture) }

    # Load order fixtures
    # Generic order fixture
    let(:generic_order_fixture)  { load_order_fixture('generic_orders') }
    let(:generic_order_attachment) { double('attachment', decoded: generic_order_fixture) }
    let(:generic_order_message) { double('attachment', attachments: [generic_order_attachment]) }
    let(:generic_email) { double('generic_email', message: generic_order_message) }

    # UCG order fixture
    let(:ucg_fixture)  { load_order_fixture('ucg_orders') }
    let(:ucg_attachment) { double('attachment', decoded: ucg_fixture) }
    let(:ucg_message) { double('message', attachments: [ucg_attachment]) }
    let(:ucg_email) { double('ucg_email', message: ucg_message) }

    # Unknown order fixture
    let(:unknown_fixture)  { load_order_fixture('unknown_orders') }
    let(:unknown_attachment) { double('attachment', decoded: unknown_fixture) }
    let(:unknown_message) { double('message', attachments: [unknown_attachment]) }
    let(:unknown_email) { double('unknown_email', message: unknown_message) }

    # Error handling fixtures
    let(:error_fixture)  { load_order_fixture('error_orders') }
    let(:error_attachment) { double('attachment', decoded: error_fixture) }
    let(:error_message) { double('message', attachments: [error_attachment]) }
    let(:error_email) { double('error_email', message: error_message, sender: double('address', address: 'from@foo.com')) }

    it 'imports generic formated csv attachments' do
        expect_any_instance_of(TaskHelper).to receive(:notify_of_import).with('generic', [])

        expect_any_instance_of(TaskHelper).to receive(:find_unread_emails).and_return([generic_email])
        expect(generic_email).to receive(:message).and_return(generic_order_message)
        expect(generic_order_message).to receive(:attachments).and_return([generic_order_attachment])
        expect(generic_order_attachment).to receive(:decoded).and_return(generic_order_fixture)
        expect(generic_email).to receive(:read!)

        unpack_order_csv(CSV.parse(generic_order_fixture)).each do |test_order|
            # Get all radios in the CSV
            frequencies = test_order.select{ |c| c.downcase.include?('radio')}
            
            order_params = {
                name: test_order['name'],
                order_source: test_order['source'],
                email: test_order['email'],
                street_address_1: test_order['address 1'],
                street_address_2: test_order['address 2'],
                city: test_order['city'],
                state: test_order['state'],
                postal_code: test_order['postal code'],
                country: test_order['country'],
                phone: test_order['phone number'].nil? ? '' : test_order['phone number'],
                shipment_priority: test_order['shipment priority'],
                frequencies: { test_order['country'] => frequencies['radio'] }
            }

            expect_any_instance_of(TaskHelper).to receive(:create_order).with(order_params)
        end

        task.execute
    end

    it 'imports ucg formated csv attachemnts' do
        expect_any_instance_of(TaskHelper).to receive(:find_unread_emails).and_return([ucg_email])
        expect_any_instance_of(TaskHelper).to receive(:send_email)
        expect(ucg_email).to receive(:message).and_return(ucg_message)
        expect(ucg_message).to receive(:attachments).and_return([ucg_attachment])
        expect(ucg_attachment).to receive(:decoded).and_return(ucg_fixture)
        expect(ucg_email).to receive(:read!)

        unpack_order_csv(CSV.parse(ucg_fixture)).each do |test_order|
            frequency = test_order['custom_info'].split('/^')[1]
            frequency_list = []
            test_order['quantity'].to_i.times do
                frequency_list << frequency
            end

            order_params = {
                name: test_order['customer_name'],
                order_source: "uncommon_goods",
                email: test_order['Email'],
                street_address_1: test_order['st_address_line1'],
                street_address_2: test_order['st_address_line2'],
                city: test_order['city'],
                state: test_order['state'],
                postal_code: test_order['postal_code'],
                country: 'US', # they only ship to US
                phone: test_order['bill_phonenum'],
                reference_number: "#{test_order['order_id']},#{test_order['shipment_id']}", # UCG order_id
                shipment_priority: shipment_priority_mapping(test_order['shipping_upgrade']),
                comments: test_order['giftmessage'],
                frequencies: { 'US' => frequency_list }
            }

            expect_any_instance_of(TaskHelper).to receive(:create_order).with(order_params)
        end

        task.execute
    end

    it 'raises a error when no order source can be matched' do
        expect_any_instance_of(TaskHelper).to receive(:find_unread_emails).and_return([unknown_email])
        expect(unknown_email).to receive(:message).and_return(unknown_message)
        expect(unknown_message).to receive(:attachments).and_return([unknown_attachment])
        expect(unknown_attachment).to receive(:decoded).and_return(unknown_fixture)      

        expect{ task.execute }.to raise_error(UnknownOrderHeaders)
    end

    context 'cleans up any stray orders, shipments, and radios when the order' do
        before(:each) do
            expect_any_instance_of(TaskHelper).to receive(:find_unread_emails).and_return([error_email])
            expect_any_instance_of(TaskHelper).to receive(:send_email)
            expect(error_email).to receive(:message).and_return(error_message)
            expect(error_message).to receive(:attachments).and_return([error_attachment])
            expect(error_attachment).to receive(:decoded).and_return(error_fixture)
            expect(error_email).to receive(:read!)
        end

        it 'has an invalid frequency' do
            expect_any_instance_of(TaskHelper).to receive(:create_order).exactly(6).times
                .and_raise(ActiveRecord::RecordInvalid)
            expect_any_instance_of(TaskHelper).to receive(:clean_up_order).exactly(6).times
            task.execute
        end

        it 'has already been imported' do
            expect_any_instance_of(TaskHelper).to receive(:create_order).exactly(6).times
                .and_raise(TaskHelper::TPROrderAlreadyCreated)
            task.execute
        end

        it 'has an invalid address' do
            expect_any_instance_of(TaskHelper).to receive(:create_order).exactly(6).times
                .and_raise(ShippoError)
            expect_any_instance_of(TaskHelper).to receive(:clean_up_order).exactly(6).times
            task.execute
        end

        it 'sends back a csv with errors as a reply email' do
            ENV['PROCESS_FAILED_ORDERS'] ='true'
            ENV['EMAILS_TO_SEND_FAILED_ORDERS'] = 'test@gmail.com'

            error_reply_params = {
                to: "from@foo.com,test@gmail.com",
                body: "Please see attached csv for 6 orders with errors",
                add_file: 'failed_orders.csv' 
            }

            expect_any_instance_of(TaskHelper).to receive(:create_order).exactly(6).times
                .and_raise(ActiveRecord::RecordInvalid)
            expect_any_instance_of(TaskHelper).to receive(:clean_up_order).exactly(6).times
            expect_any_instance_of(TaskHelper).to receive(:send_reply).with(error_email, error_reply_params)
            task.execute
        end
    end

    def load_order_fixture(fixture_name)
        File.read("spec/fixtures/#{fixture_name}.csv")
    end

    def shipment_priority_mapping(priority_string)
        if priority_string.include?('Economy') || priority_string.include?('Standard')
            'economy'
        elsif priority_string.include?('Express')
            'express'
        elsif priority_string.include?('Preferred') || priority_string.include?('Priority')
            'priority'
        end
    end

    def unpack_order_csv(csv)
        headers = csv.shift
        headers = headers.map(&:downcase)
        orders = []
        csv.each do |order|
            hash = {}
            headers.each_with_index do |header,i|
                # don't include empty values from the csv
                next if order[i].nil?
                # If a radio frequency put in an array
                if header.include?('radio')
                    # initalize radio array if it's nil
                    hash[header] = [] if hash[header].nil?
                    hash[header] << order[i]
                else
                    hash[header] = order[i]
                end
            end
            orders << hash
        end
        orders
    end
  end
end