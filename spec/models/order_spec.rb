require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:model) { described_class.new(
    first_name: '9374889691090496006367',
    last_name: 'shipped',
    address: '123 West 9th St., City, State, USA',
    order_source: 'squarespace',
    email: 'foo@bar.com')
  }

  it 'valid with valid attributes' do
    expect(model).to be_valid
  end

  it 'is not valid without a first name' do
    model.first_name = nil
    expect(model).to_not be_valid
  end

  it 'is not valid without a last name' do
    model.last_name = nil
    expect(model).to_not be_valid
  end

  it 'is valid when the order source is squarespace' do
    model.order_source = 'squarespace'
    expect(model).to be_valid
  end

	it 'is valid when the order source is kickstarter' do
    model.order_source = 'kickstarter'
    expect(model).to be_valid
  end

	it 'is not valid when the order source is not squarespace or kickstarter' do
    model.order_source = 'foo'
    expect(model).to_not be_valid
  end

  it 'is not valid without an address' do
  	model.address = nil
  	expect(model).to_not be_valid
  end

  it 'is not valid without an email' do
  	model.email = nil
  	expect(model).to_not be_valid
  end

  it 'is not valid without a correctly formated email' do
  	model.email = 'not an email@email'
  	expect(model).to_not be_valid
  end
end
