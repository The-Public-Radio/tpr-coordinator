require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:model) { build(:order) }

  it 'valid with valid attributes' do
    expect(model).to be_valid
  end

  it 'is not valid without a name' do
    model.name = nil
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

  it 'is valid when the order source is uncommon_goods' do
    model.order_source = 'uncommon_goods'
    expect(model).to be_valid
  end

  it 'is valid when the order source is wbez' do
    model.order_source = 'WBEZ'
    expect(model).to be_valid
  end

  it 'is valid when the order source is kuer' do
    model.order_source = 'KUER'
    expect(model).to be_valid
  end
	
  it 'is valid when the order source is LGA' do
    model.order_source = 'LGA'
    expect(model).to be_valid
  end

  it 'is valid when the order source is WFAE' do
    model.order_source = 'WFAE'
    expect(model).to be_valid
  end

  it 'is valid when the order source is KERA' do
    model.order_source = 'KERA'
    expect(model).to be_valid
  end

  it 'is valid when the order source is KXT' do
    model.order_source = 'KXT'
    expect(model).to be_valid
  end

  it 'is valid when the order source is warranty' do
    model.order_source = 'warranty'
    expect(model).to be_valid
  end

	it 'is not valid when the order source is not squarespace or kickstarter' do
    model.order_source = 'foo'
    expect(model).to_not be_valid
  end

  skip 'is not valid without an email' do
  	model.email = ''
  	expect(model).to_not be_valid
  end

  it 'is valid with a nil email' do
    model.email = nil
    expect(model).to be_valid
  end

  it 'is not valid without a correctly formated email' do
  	model.email = 'not an email@email'
  	expect(model).to_not be_valid
  end

  it 'counts the number of radios in an order' do
    order_id = create(:uncommon_goods).id

    expect(Order.num_radios_in_order(order_id)).to be 6
  end
end
