require "rails_helper"

describe "orders:send_uncommon_goods_notification", type: :rake do

    it "preloads the Rails environment" do
        expect(task.prerequisites).to include "environment"
    end

    context 'from the tprorder@gmail.com gmail account' do
        # Stub gmail client
        let(:stub_gmail_client) { double('gmail', deliver: false ) }

        it 'sends an emails with the shipments csv to uncommon_goods' do
            # We only want to send orders that are in a 'boxed', 'transit', 'delivered'
            email_to_send_invoice_to = ENV['UNCOMMON_GOODS_INVOICING_EMAILS'].split(',')

            retailer = create(:retailer, name: 'Uncommon Goods', source: 'uncommon_goods')
            orders_not_to_notify = create_list(:invoiced_true, 2)
            orders_not_to_notify += create_list(:invoiced_boxed_false, 2)
            orders_to_notify = create_list(:uncommon_goods, 3)

            invoice_name = "Centerline Labs LLC Shipments #{Date.today}.csv"

            # Add each order to invoice csv
            CSV.open(invoice_name, "w") do |csv|
                # Add headers to invoice csv
                csv <<  ['order_id', 'shipment_id', 'usps_tracking_number', 'quantity', 'cost_of_goods', 'shipping_handling_costs']
                # Add each shipment to order
                orders_to_notify.each do |order|
                    order.shipments.each do |shipment|
                        ucg_order_id, ucg_shipment_id = order.reference_number.split(',')
                        num_radios = shipment.radio.count
                        csv << [ucg_order_id, ucg_shipment_id, shipment.tracking_number, num_radios, Radio::PRICE * num_radios, 0]
                    end
                end
            end

            email_to_send_invoice_to.each do |email|

                email_params = {
                    to: email,
                    subject: "Centerline Labs LLC Shipments #{Date.today}",
                    add_file: invoice_name
                }

                expect_any_instance_of(TaskHelper).to receive(:send_email).with(email_params)
            end

            task.execute

            # make sure all send orders are marked as notified: true
            orders_to_notify.each do |order|
                expect{ order.reload }.to change{ order.notified }.from(false).to(true)
            end

            orders_not_to_notify.each do |order|
                expect{ order.reload }.to_not change{ order.notified }
            end

            File.delete(invoice_name)
        end
    end
end


