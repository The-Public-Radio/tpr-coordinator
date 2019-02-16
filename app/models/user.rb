require 'uri'

class User < ApplicationRecord
  validates_presence_of :name
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "only allows valid emails" }
end
