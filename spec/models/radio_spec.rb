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

  it 'valid with quality_control_status of passed, failed_appearance, or failed_functionality' do
    model.quality_control_status = 'passed'
    expect(model).to be_valid

    model.quality_control_status = 'failed_functionality'
    expect(model).to be_valid

    model.quality_control_status = 'failed_appearance'
    expect(model).to be_valid

    model.quality_control_status = 'failed'
    expect(model).to_not be_valid
  end

  describe 'valid with country_code' do
    eu = ['AE','BE','BG','CZ','DE','EE','IE','EL','ES','FR','FO','HR','IT','CY','LV','LT','LU','HU','MT','NL','NZ','AT','PL','PT','RO','SI','SK','FI','SE','UK','GB','DK','CH','ZA']
    america = ['US','CA','AI','AG','AW','BS','BB','BZ','BM','VG','CA','KY','CR','CU','CW','DM','DO','SV','GL','GD','GP','GT','HT','HN','JM','MQ','MX','PM','MS','CW','KN','NI','PA','PR','KN','LC','PM','VC','TT','TC','VI','SX','BQ','SA','SE','AR','BO','BR','CL','CO','EC','FK','GF','GY','PY','PE','SR','UY','VE']
    asia = ['JP','AU','AF','AM','AZ','BH','BD','BT','BN','KH','CN','CX','CC','IO','GE','HK','IN','ID','IR','IQ','IL','JO','KZ','KP','KR','KW','KG','LA','LB','MO','MY','MV','MN','MM','NP','OM','PK','PH','QA','SA','SG','LK','SY','TW','TJ','TH','TR','TM','AE','UZ','VN','YE','PS']

    it 'from europe' do
      eu.each do |country|
        model.country_code = country
        expect(model).to be_valid
      end
    end

    it 'from Asia' do
      asia.each do |country|
        model.country_code = country
        expect(model).to be_valid
      end
    end

    it 'from america' do
      america.each do |country|
        model.country_code = country
        expect(model).to be_valid
      end
    end
   
   it 'that can be nil' do
    model.country_code = nil
    expect(model).to be_valid
   end
  end
end
