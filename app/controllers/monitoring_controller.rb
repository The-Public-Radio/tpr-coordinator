class MonitoringController < ApplicationController

  def health
    # TODO make a basic DB call
    # ActiveRecord::Base.connection.execute('SELECT 'Pong' as message')

    head :ok
  rescue => e
    Rails.logger.fatal "health check failed: #{e.inspect}"
    render status: :internal_server_error,
           json: { error_class: e.class.to_s, error_message: e.message }
  end
end
