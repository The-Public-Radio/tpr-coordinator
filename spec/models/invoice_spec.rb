require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before do
    create_list(:uncommon_goods, 3)
    @retailer = Retailer.create!(name: 'Uncommon Goods', source: 'uncommon_goods', quickbooks_customer_id: 0)
    @invoice = Invoice.for_retailer(@retailer)
  end

  describe 'for_retailer' do
    it 'sets orders' do
      expect(@invoice.orders.count).to eq 3
    end

    it 'set the retailer attribute' do
      expect(@invoice.retailer).to be @retailer
    end

    it 'sets the radio_count' do
      expect(@invoice.radio_count).to eq 18
    end

    it 'sets the radio total' do
      expect(@invoice.radio_total).to eq 607.50
    end

    it 'sets the shipping total' do
      expect(@invoice.shipping_total).to eq 53.70
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

  describe '#mark_orders_as_notified!' do
    it 'sets Order#notified to true' do
      @invoice.mark_orders_as_notified!

      Order.all.each do |order|
        expect(order.notified).to be true
      end
    end
  end
end
