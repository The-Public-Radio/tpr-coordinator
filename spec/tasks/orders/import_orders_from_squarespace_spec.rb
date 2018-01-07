require "rails_helper"

describe "orders:import_orders_from_squarespace", type: :rake do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  context 'from the tprorder@gmail.com gmail account' do

    it 'imports all pendings orders from squarespace' do
        skip('todo')
        # notify_email_params = {
        #     to: 'testnotify@foo.com',
        #     subject: "TPR Coordinator: UCG Import Complete #{Date.today}",
        #     body: "Uncommon Goods import complete with 0 failed order(s)! \n []"
        # }
        # expect_any_instance_of(TaskHelper).to receive(:send_email).with(notify_email_params)

        # expect_any_instance_of(TaskHelper).to receive(:find_unread_emails).and_return([generic_email])
        # expect(generic_email).to receive(:message).and_return(generic_order_message)
        # expect(generic_order_message).to receive(:attachments).and_return([generic_order_attachment])
        # expect(generic_order_attachment).to receive(:decoded).and_return(generic_order_fixture)
        # expect(generic_email).to receive(:read!)

        # unpack_order_csv(CSV.parse(generic_order_fixture)).each do |test_order|
        #     order_params = {
        #         name: test_order['Name'],
        #         order_source: "other",
        #         email: test_order['Email'],
        #         street_address_1: test_order['Address 1'],
        #         street_address_2: test_order['Address 2'],
        #         city: test_order['City'],
        #         state: test_order['State'],
        #         postal_code: test_order['Postal Code'],
        #         country: test_order['Country'],
        #         phone: test_order['Phone Number'].nil? ? '' : test_order['Phone Number'],
        #         shipment_priority: test_order['Shipment Priority'],
        #         frequencies: test_order['Radio']
        #     }

        #     expect_any_instance_of(TaskHelper).to receive(:create_order).with(order_params)
        # end

        # task.execute
    end
  end
end