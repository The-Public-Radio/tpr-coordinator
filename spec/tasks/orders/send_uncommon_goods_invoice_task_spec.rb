require "rails_helper"

describe "orders:send_uncommon_goods_invoice", type: :rake do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end
end