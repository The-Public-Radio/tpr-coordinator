require 'rails_helper'

RSpec.describe Radio, type: :model do
  it 'is not valid without a frequency' do
    radio = Radio.new(frequency: nil)
    expect(radio).to_not be_valid
  end
end
