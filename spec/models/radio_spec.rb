require 'rails_helper'

RSpec.describe Radio, type: :model do
  let(:model) { described_class.new(frequency: '98.1') }

  it 'valid with valid attributes' do
    expect(model).to be_valid
  end

  it 'is not valid without a frequency' do
    model.frequency = nil
    expect(model).to_not be_valid
  end
end
