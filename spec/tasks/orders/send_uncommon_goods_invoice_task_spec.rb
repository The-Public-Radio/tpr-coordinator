require "rails_helper"

describe "orders:send_uncommon_goods_invoice", type: :rake do

    it "preloads the Rails environment" do
        expect(task.prerequisites).to include "environment"
    end

    context 'from the tprorder@gmail.com gmail account' do
        # Stub gmail client
        let(:stub_gmail_client) { double('gmail', deliver: false ) }

        it 'sends an emails with an invoice csv to uncommon_goods' do
            # We only want to send orders that are in a 'boxed', 'transit', 'delivered'
            email_to_send_invoice_to = ENV['UNCOMMON_GOODS_INVOICING_EMAILS']

            create_list(:invoiced_true, 2)
            orders_to_invoice = create_list(:invoiced_false, 3)
            invoice_name = "Centerline Labs LLC Invoice #{Date.today}.csv"

            # Add each order to invoice csv
            CSV.open(invoice_name, "w") do |csv|
                # Add headers to invoice csv
                csv <<  ['order_id', 'shipment_id', 'usps_tracking_number', 'cost_of_goods']
                # Add each shipment to order
                orders_to_invoice.each do |order|
                    order.shipments.each do |shipment|
                        ucg_order_id, ucg_shipment_id = order.reference_number.split(',')
                        csv << [ucg_order_id, ucg_shipment_id, shipment.tracking_number, 33.75 * shipment.radio.count]
                    end
                end
            end

            email_params = {
                from: 'billing@foo.com',
                to: email_to_send_invoice_to,
                subject: "Centerline Labs LLC Invoice #{Date.today}",
                add_file: invoice_name
            }

            deliver_mock = double('deliver')

            # Assertions
            assert_gmail_connect

            expect(stub_gmail_client).to receive(:deliver).and_yield(deliver_mock).and_return(true)
            
            expect(deliver_mock).to receive(:to).with(email_params[:to])

            task.execute 

            # make sure all send orders are marked as invoiced: true
            orders_to_invoice.each do |order|
                expect{ order.reload }.to change{ order.invoiced }.from(false).to(true)
            end

            File.delete(invoice_name)
        end
    end

    def assert_gmail_connect
        # Grab configuration
        username = ENV['GMAIL_USERNAME']
        password = ENV['GMAIL_PASSWORD']

        # Assert and return gmail client
        expect(Gmail).to receive(:connect!).with(username, password).and_return(stub_gmail_client)
    end
end


