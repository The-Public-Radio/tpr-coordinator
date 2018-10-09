class QboAuthController < ApplicationController
  skip_before_action :authorize

  def index
    redirect_uri = 'http://localhost:3000/qbo_auth/callback'
    @grant_url = ::QB_OAUTH2_CONSUMER.auth_code.authorize_url(redirect_uri: redirect_uri,
                                                              response_type: 'code',
                                                              state: 'none',
                                                              scope: 'com.intuit.quickbooks.accounting')
  end

  def callback
    redirect_uri = 'http://localhost:3000/qbo_auth/callback'

    if result = ::QB_OAUTH2_CONSUMER.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
      access_token = result.token
      refresh_token = result.refresh_token
      realm_id = params[:realmId]

      puts access_token
      puts refresh_token
      puts realm_id

      if creds = QuickbooksCredential.first
        creds.update_attributes(
          access_token: access_token,
          refresh_token: refresh_token,
          realm_id: realm_id,
        )
      else
        QuickbooksCredential.create!(
          access_token: access_token,
          refresh_token: refresh_token,
          realm_id: realm_id,
        )
      end
    else
      raise 'Error getting the OAUTH credentials'
    end
  end
end
