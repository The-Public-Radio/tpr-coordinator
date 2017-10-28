describe "rake orders:import_orders_from_email", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "checks gmail for any unread mssages" do
    username = ENV['GMAIL_USERNAME']
    password = ENV['GMAIL_PASSWORD']
    orders_email = ENV['ORDER_PROCESSING_EMAIL']

    gmail_stub_message = {}
    stub_order_csv = CSV.new('test,csv')

    expect(Gmail).to receive(:connect!).with(username, password).and_return

    # expect_any_instance_of(Gmail::Mailbox).to receive(:find).with(:unread, from: orders_email).once
    # returns array of Mail::Message
    # expect_any_instance_of(Mail::Message).to receive(:attachments)

    expect_any_instance_of(Mail::Body).to receive(:decode).and_return(stub_order_csv).once

    # a.body.decoded

    expect_any_instance_of(Gmail::Message).to receive(:read!).once

    # Returns array of Mail::Part 
    # email.message.attachments.each do |f|
    #   
    # end
    # 
    # email.read!
    # 

    task.execute
  end
end