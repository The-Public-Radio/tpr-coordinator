require "rails_helper"

describe "radios:send_radios_created_today_email", type: :rake do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it 'notifies ops@tpr of how many orders were imported that day' do
  	radio_count = 4
    create(:radio_boxed)
    create_list(:radio_inital_order, 3)

    notify_email_params = {
      to: 'testnotify@foo.com',
      subject: "TPR Coordinator: #{radio_count} radios were ordered today",
      body: "Radios created today:\n\tother: 4"
    } 
    expect_any_instance_of(TaskHelper).to receive(:send_email).with(notify_email_params)

    task.execute
  end
end