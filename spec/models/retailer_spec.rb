require 'rails_helper'

RSpec.describe Retailer, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :source }
    it { should validate_presence_of :quickbooks_customer_id }
  end
end
