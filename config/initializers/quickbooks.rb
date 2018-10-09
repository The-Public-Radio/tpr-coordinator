# Set up OAUTH
QBO_CLIENT_ID = ENV['QBO_CLIENT_ID']
QBO_CLIENT_SECRET = ENV['QBO_CLIENT_SECRET']

oauth_params = {
  :site => "https://appcenter.intuit.com/connect/oauth2",
  :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
  :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
}

::QB_OAUTH2_CONSUMER = OAuth2::Client.new(QBO_CLIENT_ID, QBO_CLIENT_SECRET, oauth_params)

# Set up the quickbooks-ruby gem
Quickbooks.sandbox_mode = ENV['QBO_PRODUCTION_MODE'] != 'true'
