describe "rake orders:import_orders_from_email", type: :task do

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

    it 'imports generic formated csv attachments' do
        email = stub_email('gmail.com')

        assert_gmail_connect
        assert_inbox_find(email)
        assert_attachment_decode('generic_orders')
        assert_email_read(email)

        expect{ task.execute }.to change(Order, :count).by(1)
    end

    it 'imports ucg formated csv attachemnts' do
        email = stub_email('ucg.com')

        assert_gmail_connect
        assert_inbox_find(email)
        assert_attachment_decode('ucg_orders')
        assert_email_read(email)

        expect{ task.execute }.to change(Order, :count).by(1)
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
        expect(stub_attachment).to receive(:decode).and_return(order_csv_fixture)
    end

    def assert_email_read(stub_email)
        # Assert marked as read after import
        # TODO: Verify this return value
        # TODO: This should be read! not read
        expect(stub_email).to receive(:read).and_return(true)
    end

    def stub_email(host)
        stub_message = double('message', attachments: [stub_attachment])

        @stub_email ||= double('email', message: stub_message,
            from: [double('from', host: host)], read: true)
    end
  end
end