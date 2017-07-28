class Order < ApplicationRecord
	has_many :shipments

	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_presence_of :order_source
	validates_inclusion_of :order_source, in: %w{squarespace kickstarter}
	validates_presence_of :address
	validates_presence_of :email
	validates_email_format_of :email, message: 'Email formated incorrectly'

end
