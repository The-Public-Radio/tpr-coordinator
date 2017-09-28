require 'api-pagination'

class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Rails::Pagination
  before_action :authorize

  def http
    api_response([], 400, 'derp')
  end

  def api_response(data, status = :ok, errors = [])
    serializer = ActiveModel::Serializer.serializer_for(data)
    ret = {
      'data' => serializer.try(:new, data),
      'errors' => Array.wrap(errors)
    }
    Rails.logger.debug("Status: #{status}")
    Rails.logger.debug("Body: #{ret}")
    render json: ret, status: status
  end

  def allowed_auth_tokens
    ENV['HTTP_AUTH_TOKENS']
  end

  def authorize
    api_response([], 400, ['No authorization header provided']) if request.headers['HTTP_AUTHORIZATION'].nil?

    auth_header = request.headers['HTTP_AUTHORIZATION'].split(' ')

    unless auth_header[0].eql?('Bearer') && allowed_auth_tokens.include?(auth_header[1])
      api_response([], 400, ['Incorret authorization header'])
    end
  end
end
