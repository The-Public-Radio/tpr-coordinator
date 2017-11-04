describe "rake orders:import_orders_from_email", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  context 'when checking gmail' do

    # Load stub order csv
    let(:stub_order_csv) { File.read('spec/fixtures/generic_orders.csv') }
    # Stub email attachment
    let(:stub_attachment) { double('attachment') }
    # Stub gmail inbox
    let(:stub_gmail_inbox) { double('inbox') }
    # Stub gmail client
    let(:stub_gmail_client) { double('gmail', inbox: stub_gmail_inbox ) }
    # Stub email
    let(:stub_message) { double('message', attachments: [stub_order_csv]) }

    # Stub emails
    let(:stub_email) { double('email', message: stub_message,
        from: [double('from', host: 'ucg.com')], read: true
        ) }

    it 'connects to the gmail api, loads unread emails, decodes and imports any attachments' do
        # Grab configuration
        username = ENV['GMAIL_USERNAME']
        password = ENV['GMAIL_PASSWORD']

        # Assert and return gmail client
        expect(Gmail).to receive(:connect!).with(username, password).and_return(stub_gmail_client)
        # Assert and return emails
        expect(Gmail).to receive(:connect!).with(username, password).and_return(stub_gmail_client)
        expect(stub_gmail_inbox).to receive(:find).with(:unread).and_return([stub_email])
        # Assert and return decoded attachment (csv)
        expect(stub_attachment).to receive(:decode).and_return(stub_order_csv).once
        # Assert marked as read after import
        # TODO: Verify this return value
        # TODO: This should be read! not read
        expect(stub_email).to receive(:read).and_return(true)

        task.execute
    end
  end
end