require "rails_helper"

describe "orders:import_orders_from_email", type: :rake do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  context 'from the tprorder@gmail.com gmail account' do

    # Stub gmail inbox
    let(:stub_gmail_inbox) { double('inbox') }
    # Stub gmail client
    let(:stub_gmail_client) { double('gmail', inbox: stub_gmail_inbox ) }
    # Stub attachment
    let(:stub_attachment) { double('attachment') }

    # Load order fixtures
    # Generic order fixture
    let(:generic_order_fixture)  { load_order_fixture('generic_orders') }
    # UCG order fixture
    let(:ucg_order_fixture)  { load_order_fixture('ucg_orders') }

    it 'imports generic formated csv attachments' do
        ENV['GENERIC_ORDER_PROCESSING_FROM_EMAIL_WHITELIST'] = 'gmail.com'
        email = stub_email('gmail.com')

        assert_gmail_connect
        assert_inbox_find(email)
        assert_attachment_decode('generic_orders')
        assert_email_read(email)

        unpack_order_csv(generic_order_fixture).each do |test_order|
            order_params = {
                name: test_order['Name'],
                order_source: "other",
                email: test_order['Email'],
                street_address_1: test_order['Address 1'],
                street_address_2: test_order['Address 2'],
                city: test_order['City'],
                state: test_order['State'],
                postal_code: test_order['Postal Code'],
                country: test_order['Country'],
                phone: test_order['Phone Number'].nil? ? '' : test_order['Phone Number'],
                shipment_priority: test_order['Shipment Priority'],
                frequencies: [test_order['Radio']]
            }

            stub_controller = double('orders_controller', make_queue_order_with_radios: nil )
            expect(OrdersController).to receive(:new).and_return(stub_controller)
            expect(stub_controller).to receive(:make_queue_order_with_radios).with(order_params)
            # TODO: Test end state expectations: order count changed
            # expect(OrdersController).to receive(:make_queue_order_with_radios).with(order_params).and_call_original
            # expect{ task.execute }.to change(Order, :count).by(4)
        end

        task.execute
    end

    it 'imports ucg formated csv attachemnts' do
        email = stub_email('ucg.com')

        assert_gmail_connect
        assert_inbox_find(email)
        assert_attachment_decode('ucg_orders')
        assert_email_read(email)

        unpack_order_csv(ucg_order_fixture).each do |test_order|
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
                reference_number: test_order['order_id'], # UCG order_id
                shipment_priority: shipment_priority_mapping(test_order['shipping_upgrade']),
                comments: test_order['giftmessage'],
                frequencies: [test_order['Custom_Info'].split('/^')[1]]
            }

            stub_controller = double('orders_controller', make_queue_order_with_radios: nil )
            expect(OrdersController).to receive(:new).and_return(stub_controller)
            expect(stub_controller).to receive(:make_queue_order_with_radios).with(order_params)
        end

        task.execute
    end

    def assert_gmail_connect
        # Grab configuration
        username = ENV['GMAIL_USERNAME']
        password = ENV['GMAIL_PASSWORD']

        # Assert and return gmail client
        expect(Gmail).to receive(:connect!).with(username, password).and_return(stub_gmail_client)
    end

    def assert_inbox_find(stub_specific_email)
        # Assert and return emails
        expect(stub_gmail_inbox).to receive(:find).with(:unread).and_return([stub_specific_email])
    end

    def assert_attachment_decode(fixture_name)
        order_csv_fixture = File.read("spec/fixtures/#{fixture_name}.csv")
        # Assert and return decoded attachment (csv)
        expect(stub_attachment).to receive(:decoded).and_return(order_csv_fixture)
    end

    def assert_email_read(email)
        # Assert marked as read after import
        # TODO: Verify this return value
        # TODO: This should be read! not read
        expect(email).to receive(:read!).and_return(true)
    end

    def load_order_fixture(fixture_name)
        CSV.read("spec/fixtures/#{fixture_name}.csv")
    end

    def stub_email(host)
        stub_message = double('message', attachments: [stub_attachment])

        @stub_email = double('email', message: stub_message,
            from: [double('from', host: host)], read: true)
    end

    def shipment_priority_mapping(priority_string)
        if priority_string.include?('Economy') || priority_string.include?('Standard') 
            'economy'
        elsif priority_string.include?('Express')
            'express'
        elsif priority_string.include?('Prefered') || priority_string.include?('Priority')
            'priority'
        end
    end

    def unpack_order_csv(csv)
        headers = csv.shift
        orders = []
        csv.each do |order|
            hash = {}
            headers.each_with_index do |header,i|
                # don't include empty values from the csv
                next if order[i].nil?
                # If a radio frequency put in an array
                if header.include?('Radio')
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