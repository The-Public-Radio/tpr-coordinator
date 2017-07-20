require 'rails_helper'

RSpec.describe Shipment, type: :model do
  let(:model) { described_class.new(tracking_number: '1Z879E930346834440') }

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
end
