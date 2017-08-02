class User < ApplicationRecord
  validates_email_format_of :email
  validates_presence_of :name
  has_secure_password
end
