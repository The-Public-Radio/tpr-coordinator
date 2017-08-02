require 'rails_helper'

RSpec.describe Radio, type: :model do
  let(:model) { described_class.new(
    frequency: '98.1',
    shipment_id: 1
    ) 
  }

  it 'valid with valid attributes' do
    expect(model).to be_valid
  end

  it 'is not valid without a frequency' do
    model.frequency = nil
    expect(model).to_not be_valid
  end

  it 'is not valid with a poorly formated frequency' do
    # Frequencies must be:
    #  - nuemeric
    #  - not over 5 characters (4 and .)
    #  - between 76 and 108
    model.frequency = '103.2356'
    expect(model).to_not be_valid

    model.frequency = '89.w2'
    expect(model).to_not be_valid

    model.frequency = '109.3'
    expect(model).to_not be_valid

    model.frequency = '75.2'
    expect(model).to_not be_valid
  end
end
