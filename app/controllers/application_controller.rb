require 'api-pagination'

class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Rails::Pagination

  def api_response(data, status = :ok, errors = [])
    serializer = ActiveModel::Serializer.serializer_for(data)
    if serializer.nil?
      ret = {
        'data' => data,
        'errors' => Array.wrap(errors)
      }
    else
      ret = {
        'data' => serializer.try(:new, data),
        'errors' => Array.wrap(errors)
      }
    end
    Rails.logger.debug("Status: #{status}")
    Rails.logger.debug("Body: #{ret}")
    render json: ret, status: status
  end
end
