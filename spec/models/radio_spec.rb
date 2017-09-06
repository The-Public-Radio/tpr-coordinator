require 'rails_helper'

RSpec.describe Radio, type: :model do
  let(:model) { build(:radio_boxed) }

  it 'valid with valid attributes' do
    expect(model).to be_valid
  end

  it 'has a unique serial_number' do
    radio_1 = create(:radio_assembled)
    model.serial_number = radio_1.serial_number
    expect(model).to_not be_valid

    model.serial_number = random_tpr_serial_number
    expect(model).to be_valid
  end

  it 'has a properly formated serial number' do
    model.serial_number = 'not a tpr serial'
    expect(model).to_not be_valid

    model.serial_number = random_tracking_number
    expect(model).to_not be_valid

    model.serial_number = random_tpr_serial_number
    expec(model).to be_valid
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
