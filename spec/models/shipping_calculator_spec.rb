require 'rails_helper'

RSpec.describe ShippingCalculator, type: :model do
  context 'calculates the shipping and handling for' do
    context 'economy shipments with' do
      let(:shipment_priority) { 'economy' }

      specify '1 radio' do
        cost = ShippingCalculator.calculate_shipping_and_handling(1, shipment_priority)
        expect(cost).to be 5.95
      end

      specify '2 radios' do
        cost = ShippingCalculator.calculate_shipping_and_handling(2, shipment_priority)
        expect(cost).to be 7.95
      end

      specify '3 radios' do
        cost = ShippingCalculator.calculate_shipping_and_handling(3, shipment_priority)
        expect(cost).to be 8.95
      end
    end

    context 'priority shipments with' do
      let(:shipment_priority) { 'priority' }

      specify '1 radio' do
        cost = ShippingCalculator.calculate_shipping_and_handling(1, shipment_priority)
        expect(cost).to be 12.95
      end

      specify '2 radios' do
        cost = ShippingCalculator.calculate_shipping_and_handling(2, shipment_priority)
        expect(cost).to be 7.95
      end

      specify '3 radios' do
        cost = ShippingCalculator.calculate_shipping_and_handling(3, shipment_priority)
        expect(cost).to be 8.95
      end
    end

    context 'express shipments with' do
      let(:shipment_priority) { 'express' }

      specify '1 radio' do
        cost = ShippingCalculator.calculate_shipping_and_handling(1, shipment_priority)
        expect(cost).to be 38.45
      end

      specify '2 radios' do
        cost = ShippingCalculator.calculate_shipping_and_handling(2, shipment_priority)
        expect(cost).to be 38.45
      end

      specify '3 radios' do
        cost = ShippingCalculator.calculate_shipping_and_handling(3, shipment_priority)
        expect(cost).to be 44.05
      end
    end
  end
end
