require 'rails_helper'

RSpec.describe InvoiceCSV, type: :model do
  before do
    orders_to_invoice = create_list(:uncommon_goods, 3)
    @csv = InvoiceCSV.new(orders_to_invoice)
  end

  describe '#initialize' do
    it 'sets orders' do
      expect(@csv.orders.count).to eq 3
    end
  end

  describe '#generate' do
    let(:output) { @csv.generate }

    it 'emits a string' do
      expect(output).to be_a String
    end

    it 'includes the headers at the top' do
      headers = output.lines.first.chomp

      expect(headers).to eq InvoiceCSV::HEADERS.join(',')
    end

    it 'includes a line for each shipment' do
      _, *shipments = output.lines

      expect(shipments.count).to eq 6
    end
  end
end
