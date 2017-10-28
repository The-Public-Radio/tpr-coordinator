describe "rake orders:import_orders_from_email", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "checks gmail for any unread mssages" do
    username = ENV['GMAIL_USERNAME']
    password = ENV['GMAIL_PASSWORD']
    expect(Gmail).to receive(:connect!).with(username, password).once
    task.execute
  end
end