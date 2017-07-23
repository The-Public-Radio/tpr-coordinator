require 'rails_helper'

RSpec.describe User, type: :model do
  let(:model) { described_class.new(
    name: 'foo',
    email: 'foo@bar.come')
  }

  it 'valid with valid attributes' do
    expect(model).to be_valid
  end

  it 'is not valid without an email' do
    model.email = nil
    expect(model).to_not be_valid
  end

  it 'is not valid without a name' do
    model.email = nil
    expect(model).to_not be_valid
  end
end
