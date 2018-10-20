require 'rails_helper'

RSpec.describe InvoiceService do
  before do
    squ = create(:retailer, name: 'Retailer 1', source: 'squarespace', generate_invoice: false)
    @ucg = create(:retailer, name: 'Retailer 2', source: 'uncommon_goods')

    create(:order, :with_shipments, order_source: squ.source, shipment_count: 1)
    create(:order, :with_shipments, order_source: @ucg.source, shipment_count: 2)
  end

  it 'generates an invoice for each retailers and marks the orders as invoiced' do
    expect_any_instance_of(QuickbooksAdapter).to receive(:create_invoice).once.and_return(nil)

    InvoiceService.generate_for_retailers

    orders = Order.where(order_source: @ucg.source)

    orders.each do |order|
      expect(order.invoiced?).to be true
    end
  end
end
