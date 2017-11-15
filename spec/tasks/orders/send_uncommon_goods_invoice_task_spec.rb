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
            email_to_send_invoice_to = ENV['UNCOMMON_GOODS_INVOICING_EMAIL']

            create_list(:invoiced_true, 2)
            orders_to_invoice = create_list(:invoiced_false, 3)
            invoice_name = "tpr_invoice_#{Date.today.to_s.gsub('-','_')}.csv"

            # Add each order to invoice csv
            CSV.open(invoice_name, "w") do |csv|
                # Add headers to invoice csv
                csv <<  ['order_id', 'tracking_number', 'cost_of_goods']
                # Add each shipment to order
                orders_to_invoice.each do |order|
                    order.shipments.each do |shipment|
                        csv << [order.reference_number, shipment.tracking_number, 33.75 * shipment.radio.count]
                    end
                end
            end

            email_params = {
                to: email_to_send_invoice_to,
                subject: 'The Public Radio Invoice',
                add_file: invoice_name
            }

            # Assertions
            assert_gmail_connect
            expect(stub_gmail_client).to receive(:deliver).with(email_params).and_return(true)
            
            task.execute

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


