require "rails_helper"

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

    it 'imports generic formated csv attachments' do
        notify_email_params = {
            to: 'testnotify@foo.com',
            subject: "TPR Coordinator: UCG Import Complete #{Date.today}",
            body: "Uncommon Goods import complete!"
        }
        expect_any_instance_of(TaskHelper).to receive(:send_email).with(notify_email_params)

        expect_any_instance_of(TaskHelper).to receive(:find_unread_emails).and_return([generic_email])
        expect(generic_email).to receive(:message).and_return(generic_order_message)
        expect(generic_order_message).to receive(:attachments).and_return([generic_order_attachment])
        expect(generic_order_attachment).to receive(:decoded).and_return(generic_order_fixture)
        expect(generic_email).to receive(:read!)

        unpack_order_csv(CSV.parse(generic_order_fixture)).each do |test_order|
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
            frequency = test_order['Custom_Info'].split('/^')[1]
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
                frequencies: frequency_list
            }

            expect_any_instance_of(TaskHelper).to receive(:create_order).with(order_params)
        end

        task.execute
    end

    it 'handles errors on import and cleans up any stray orders, shipments, and radios' do
        # error_email_params = {
        #     add_file: 'some/error/csv'
        # }

        expect_any_instance_of(TaskHelper).to receive(:find_unread_emails).and_return([email_with_bad_orders])
        # expect_any_instance_of(TaskHelper).to receive(:send_reply).with(error_email_params)
        expect_any_instance_of(TaskHelper).to receive(:create_order).with(bad_address_params).and_raise(ShippoError)
        expect_any_instance_of(TaskHelper).to receive(:create_order).with(bad_frequency_params).and_raise(ActiveRecordValidationError)
        expect_any_instance_of(TaskHelper).to receive(:create_order).with(order_already_imported_params).and_raise(OrderExistsError)

        expect(ucg_email).to receive(:message).and_return(ucg_message)
        expect(ucg_message).to receive(:attachments).and_return([ucg_attachment])
        expect(ucg_attachment).to receive(:decoded).and_return(ucg_fixture)
        expect(ucg_email).to receive(:read!)

        task.execute
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