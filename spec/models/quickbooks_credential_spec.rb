require 'rails_helper'

RSpec.describe QuickbooksCredential, type: :model do
  describe 'validations' do
    it { should validate_presence_of :access_token }
    it { should validate_presence_of :refresh_token }
    it { should validate_presence_of :realm_id }
  end
end
