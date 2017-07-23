class User < ApplicationRecord
  validates_presence_of :email
  validates_presence_of :name
end
