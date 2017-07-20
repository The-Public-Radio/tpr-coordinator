require 'rails_helper'

RSpec.describe Shipment, type: :model do
  let(:model) { described_class.new(
    tracking_number: '1Z879E930346834440',
    status: 'shipped')
  }

  it 'valid with valid attributes' do
    expect(model).to be_valid
  end

  it 'is not valid without a tracking_number' do
    model.tracking_number = nil
    expect(model).to_not be_valid
  end

  it 'is not valid with an not valid tracking number' do
    model.tracking_number = 'asdf3t45TRACKINGFAKE'
    expect(model).to_not be_valid
  end

  it 'is valid when date is nil' do
    model.ship_date = nil
    expect(model).to be_valid
  end

  it 'is valid only when date is a date object or nil' do
    model.ship_date = Date.new
    expect(model).to be_valid

    model.ship_date = nil
    expect(model).to be_valid

    model.ship_date = 'this is not a date'
    expect(model).to_not be_valid
  end

  context 'a shipment has a status that' do
    it 'is valid when shipped, fulfillment, or created' do
      model.status = 'created'
      expect(model).to be_valid

      model.status = 'fulfillment'
      expect(model).to be_valid

      model.status = 'shipped'
      expect(model).to be_valid

      model.status = 'done'
      expect(model).to_not be_valid
    end
  end
end
