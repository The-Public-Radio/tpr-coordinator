class Retailer < ApplicationRecord
  validates :name, presence: true
  validates :source, presence: true
  validates :quickbooks_customer_id, presence: true

  def self.for_source(source)
    self.find_by(source: source)
  end
end
