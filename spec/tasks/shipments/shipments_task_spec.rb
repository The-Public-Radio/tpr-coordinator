describe "rake shipments:check_shipment_status", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "runs gracefully with no subscribers" do
    expect { task.execute }.not_to raise_error
  end

  it "logs to stdout" do
    expect { task.execute }.to output("Checking package shipment status for 5 shipments").to_stdout
  end

  it "calls the shippo API to check the tracking status of the shipment" do
    shipments = create_list(:kickstarter)

    shipments.each do |shipment|
      tracking_number = shipment.tracking_number 

      expect(Shippo::Track).to receive(:get).with(tracking_number, 'usps').and_return(shippo_response_object).once

    task.execute

    expect(subscriber).to have_received_invoice
  end

  it "only checks shipments that are of shipment_status: boxed" do

    task.execute

    expect(dead_mans_snitch_request).to have_been_requested
  end

  matcher :have_received_invoice do
    match_unless_raises do |subscriber|
      expect(last_email_sent).to be_delivered_to subscriber.email
      expect(last_email_sent).to have_subject 'Your invoice'
    end
  end

end