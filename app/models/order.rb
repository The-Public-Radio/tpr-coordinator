class Order < ApplicationRecord
	has_many :shipments

	if ENV['TPR_ORDER_SOURCES'].nil?
		order_sources = []
	else
		order_sources = ENV['TPR_ORDER_SOURCES'].split(',')
	end

	validates_presence_of :name
	validates_inclusion_of :order_source, in: order_sources
	validates_email_format_of :email, message: 'formated incorrectly', allow_nil: true
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
