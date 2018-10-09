class Retailer < ApplicationRecord
  validates :name, presence: true
  validates :source, presence: true
  validates :quickbooks_customer_id, presence: true
end
