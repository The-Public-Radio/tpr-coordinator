require 'rails_helper'

describe 'orders:send_uncommon_goods_shipments', type: :rake do

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'sends the email with the csv' do
    create(:retailer, name: 'Uncommon Goods', source: 'uncommon_goods')

    create(:order, notified: false)
    create(:invoiced_boxed_false)
    order1, order2 = create_list(:uncommon_goods, 2)

    email1, email2 = ENV['UNCOMMON_GOODS_INVOICING_EMAILS'] .split(',')

    expect_any_instance_of(TaskHelper).to receive(:send_email) do |_, args|
      expect(args[:to]).to eq email1
      expect(args[:subject]).to match(/Centerline Labs LLC Shipments \d{4}-\d{2}-\d{2}/)

      csv = File.read(args[:add_file])
      rows = csv.split("\n")

      expect(rows.count).to eq 5
      expect(rows[1]).to start_with order1.reference_number
      expect(rows[2]).to start_with order1.reference_number
      expect(rows[3]).to start_with order2.reference_number
      expect(rows[4]).to start_with order2.reference_number
    end

    expect_any_instance_of(TaskHelper).to receive(:send_email) do |_, args|
      expect(args[:to]).to eq email2
    end

    task.execute
  end
end
