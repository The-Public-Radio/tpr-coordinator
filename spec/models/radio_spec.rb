require 'rails_helper'

RSpec.describe Radio, type: :model do
  it 'valid with valid attributes' do
    radio = Radio.new(frequency: '98.1')
    expect(radio).to be_valid
  end

  it 'is not valid without a frequency' do
    radio = Radio.new(frequency: nil)
    expect(radio).to_not be_valid
  end
end
