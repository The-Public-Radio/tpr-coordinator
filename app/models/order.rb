class Order < ApplicationRecord
	has_many :shipments

	validates_presence_of :name
	validates_inclusion_of :order_source, in: %w{squarespace kickstarter uncommon_goods other WBEZ warranty KUER}
	validates_email_format_of :email, message: 'formated incorrectly', allow_nil: true


	def self.num_radios_in_order(order_id)
		order = Order.find(order_id)

		radio_count = 0
		order.shipments.each do |shipment|
			radio_count += shipment.radio.count
		end
		radio_count
	end
end
