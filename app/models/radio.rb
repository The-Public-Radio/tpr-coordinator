class Radio < ApplicationRecord

  # set regions
  eu = ['AE','BE','BG','CZ','DE','EE','IE','EL','ES','FR','FO','HR','IT','CY','LV','LT','LU','HU','MT','NL','NZ','AT','PL','PT','RO','SI','SK','FI','SE','UK','GB','DK','CH','ZA']
  america = ['US','CA','AI','AG','AW','BS','BB','BZ','BM','VG','CA','KY','CR','CU','CW','DM','DO','SV','GL','GD','GP','GT','HT','HN','JM','MQ','MX','PM','MS','CW','KN','NI','PA','PR','KN','LC','PM','VC','TT','TC','VI','SX','BQ','SA','SE','AR','BO','BR','CL','CO','EC','FK','GF','GY','PY','PE','SR','UY','VE']
  asia = ['JP', 'AU','AF','AM','AZ','BH','BD','BT','BN','KH','CN','CX','CC','IO','GE','HK','IN','ID','IR','IQ','IL','JO','KZ','KP','KR','KW','KG','LA','LB','MO','MY','MV','MN','MM','NP','OM','PK','PH','QA','SA','SG','LK','SY','TW','TJ','TH','TR','TM','AE','UZ','VN','YE','PS']

	belongs_to :shipment, optional: true
  validates_numericality_of :frequency,
  	greater_than_or_equal_to: 76,
  	less_than_or_equal_to: 108,
  	message: 'Frequency is not valid!',
  	allow_nil: true
  validates :frequency, length: { maximum: 5 }
  validates_inclusion_of :boxed, in: [true, false], allow_nil: true
  validates :serial_number, uniqueness: true, allow_nil: true
  validates_inclusion_of :country_code, in: eu + america + asia, allow_nil: true
  validates_inclusion_of :quality_control_status, in: %w{passed failed_functionality failed_appearance}, allow_nil: true
end
