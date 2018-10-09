require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before do
    create_list(:uncommon_goods, 3)
    retailer = Retailer.create!(name: 'Uncommon Goods', source: 'uncommon_goods', quickbooks_customer_id: 0)
    @invoice = Invoice.for_retailer(retailer)
  end

  describe '#initialize' do
    it 'sets orders' do
      expect(@invoice.orders.count).to eq 3
    end
  end

  describe '#mark_orders_as_invoiced!' do
    it 'sets Order#invoiced to true' do
      @invoice.mark_orders_as_invoiced!

      Order.all.each do |order|
        expect(order.invoiced).to be true
      end
    end
  end
end
