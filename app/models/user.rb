class User < ApplicationRecord
  validates_email_format_of :email
  validates_presence_of :name
end
