class ShipmentStatusCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    check_status
  end

  def check_status
  	
  end
end
