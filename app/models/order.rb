class Order < ApplicationRecord
	has_many :shipments, dependent: :destroy

	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_inclusion_of :order_source, in: %w{squarespace kickstarter other}
	validates_presence_of :address
	validates_email_format_of :email, message: 'Email formated incorrectly'

end
