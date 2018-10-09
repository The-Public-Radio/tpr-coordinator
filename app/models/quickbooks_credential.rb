class QuickbooksCredential < ApplicationRecord
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :realm_id, presence: true
end
