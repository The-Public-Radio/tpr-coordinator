class QuickbooksCredential < ApplicationRecord
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :realm_id, presence: true

  def refresh!
    oauth_client.refresh!

    self.access_token = oauth_client.token
    self.refresh_token = oauth_client.refresh_token

    save!
  end

  def oauth_client
    @oauth_client ||= OAuth2::AccessToken.new(
      ::QB_OAUTH2_CONSUMER,
      access_token,
      { refresh_token: refresh_token }
    )
  end
end
