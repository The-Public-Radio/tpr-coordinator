describe "rake orders:import_orders_from_email", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "checks gmail for any unread mssages" do

    task.execute
  end
end