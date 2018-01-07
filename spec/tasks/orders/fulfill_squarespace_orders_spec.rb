require "rails_helper"

describe "orders:fulfill_squarespace_orders", type: :rake do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  context 'from the squarespace' do

    it 'imports all pendings orders from squarespace' do
        skip('todo')

        task.execute
    end
  end
end