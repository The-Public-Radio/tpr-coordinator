class Order < ApplicationRecord
  has_many :shipments

  scope :uninvoiced, -> { where(invoiced: false) }

  if ENV['TPR_ORDER_SOURCES'].nil?
    order_sources = []
  else
    order_sources = ENV['TPR_ORDER_SOURCES'].split(',')
  end

  validates :name, presence: true
  validates :order_source, inclusion: { in: order_sources }
  validates :email, email_format: { message: 'formatted incorrectly' }, allow_blank: true, allow_nil: false

  after_initialize :init

  def init
    self.invoiced ||= false
    self.notified ||= false
  end

  def self.num_radios_in_order(order_id)
    order = Order.find(order_id)
    radio_count = 0

    order.shipments.each do |shipment|
      radio_count += shipment.radio.count
    end

    radio_count
  end
end
