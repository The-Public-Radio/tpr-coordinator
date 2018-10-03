require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before do
    create_list(:uncommon_goods, 3)
    @invoice = Invoice.for_source('uncommon_goods') # TODO: Define this string elsewhere
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
