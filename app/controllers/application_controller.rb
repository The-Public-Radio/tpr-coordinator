require 'api-pagination'

class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Rails::Pagination

  def api_response(data, status = :ok, errors = [])
    serializer = ActiveModel::Serializer.serializer_for(data)
    ret = {
      'data' => serializer.try(:new, data),
      'errors' => Array.wrap(errors)
    }
    render json: ret, status: status
  end

  def paginated_api_response(data, status = :ok, errors = [])
    serializer = ActiveModel::Serializer.serializer_for(data)
    data = serializer.try(:new, data)
    paginate json: data, status: status, per_page: 1
  end
end
