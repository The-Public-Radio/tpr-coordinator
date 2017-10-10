class Order < ApplicationRecord
	has_many :shipments

	validates_presence_of :name
	validates_inclusion_of :order_source, in: %w{squarespace kickstarter other WBEZ}
	validates_email_format_of :email, message: 'formated incorrectly'

end
