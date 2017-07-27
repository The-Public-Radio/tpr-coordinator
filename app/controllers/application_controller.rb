class ApplicationController < ActionController::API
  include ActionController::Serialization

  def api_response(data, status = :ok, errors = [])
    serializer = ActiveModel::Serializer.serializer_for(data)
    ret = {
      'data' => serializer.try(:new, data),
      'errors' => Array.wrap(errors)
    }
    render json: ret, status: status
  end
end
