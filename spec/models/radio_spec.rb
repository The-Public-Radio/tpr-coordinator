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

  it 'valid with quality_control_status of passed, failed_mech, or failed_software' do
    model.quality_control_status = 'passed'
    expect(model).to be_valid

    model.quality_control_status = 'failed_software'
    expect(model).to be_valid

    model.quality_control_status = 'failed_mech'
    expect(model).to be_valid

    model.quality_control_status = 'failed'
    expect(model).to_not be_valid
  end
end
