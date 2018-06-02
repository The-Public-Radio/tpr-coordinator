require 'httparty'
require 'date'

class ShipmentInvalid < StandardError
end

class NoShipmentFound < StandardError
end

class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:index, :show, :update, :destroy, :next_unboxed_radio]

  # GET /shipments
  # GET /shipments.json
  def index
    api_response(@shipment)
  end

  # GET /shipments/1
  # GET /shipments/1.json
  def show
    api_response(@shipment)
  end

  # POST /shipments
  # POST /shipments.json
  def create
    @shipment = Shipment.new(shipment_params)

    set_up_default_shipment

    if @shipment.save
      api_response(@shipment, :created)
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shipments/1
  # PATCH/PUT /shipments/1.json
  def update
    mutable_params = shipment_params
    if mutable_params['shipment_status'] == 'shipped'
      mutable_params['ship_date'] = Date.today.to_s
    end

    if @shipment.update(mutable_params)
      api_response(@shipment)
    else
      api_response([], 422, ['Shipment updates are invalid'])
    end
  end

  # DELETE /shipments/1
  # DELETE /shipments/1.json
  def destroy
    @shipment.destroy
  end

  # Next unboxed radio in the shipment
  def next_unboxed_radio
    # sort by object creation time to always get the same order
    api_response(@shipment.next_unboxed_radio)
  end

  def next_label_created_shipment
    # Get all label_created shipments with radios and order by:
    # 1) priority_processing
    # 2) shipment_priority
    # 3) created_at
  
    # This is known to put 'express' shipments after 'priority' shipments due alphabetical sorting
    # Currently it's priority -> express -> economy when it should be express -> priority -> economy
    # TODO: Fix this to sort shipment_priority correctly. 
    label_created_shipments = Shipment.where(shipment_status: 'label_created')
      .order(:priority_processing, shipment_priority: :desc, created_at: :asc)

    @shipment = label_created_shipments.select do |s|
      # Does the shipment have radios?
      has_radios = s.radio.any?
      # Is it from an order_source that we want in the main queue?
      order_source_blacklisted = order_source_processing_blacklist.include?(s.order.order_source)

      has_radios && !order_source_blacklisted
    end[0]

    # Return top of the queue
    api_response(@shipment)
  end

  def order_source_processing_blacklist
    ENV['TPR_ORDER_SOURCES_PROCESSING_BLACKLIST'].nil? ? '' : ENV['TPR_ORDER_SOURCES_PROCESSING_BLACKLIST']
  end

  def shipment_label_created_count
    count = Shipment.where(shipment_status: 'label_created').count
    response = {
      data: {
        shipment_count: count
      },
      error: {}
    }
    render json: response, status: :ok
  end

  def create_shipment_from_order(order, frequencies, shipment_priority = nil)
    @shipment = Shipment.new(order_id: order.id)
    @order = order

    set_up_default_shipment(frequencies, shipment_priority)

    Rails.logger.debug("Saving new shipment for order #{order.id}: #{@shipment.attributes}")
    unless @shipment.save
      Rails.logger.error(@shipment.errors)
      raise ShipmentInvalid(@shipment.errors)
    end
  end

  private
    attr_accessor :shipment
   
    class RadioInvalid < StandardError
    end

    def set_up_default_shipment(frequencies = params['shipment']['frequencies'], shipment_priority = params['shipment']['shipment_priority'])

      if !@order.nil?
        @order = Order.find(shipment.order_id)
      else
        # Make sure there's a country code
        @order = Order.new(country: 'US')
      end

      # Create radios for shipment
      if !frequencies.nil?
        @shipment.save # must save shipment to have an id to associate radios to
        frequencies.each do |frequency|
          radio = Radio.create(frequency: frequency, boxed: false, country_code: @order.country, shipment_id: @shipment.id)
          unless radio.save
            Rails.logger.error(radio.errors)
            raise RadioInvalid(radio.errors)
          end
        end
      end

      # Check priority, default to economy
      @shipment.shipment_priority = shipment_priority.nil? ? 'economy' : shipment_priority.downcase

      # Create tracking number and label_url
      if @shipment.tracking_number.nil?
        Rails.logger.info('No tracking number provided for new shipment')
        if @shipment.shippo_reference_id.empty? 
          Rails.logger.info('No Shippo shipment created. Creating shipment.')
          response = ShippoHelper.create_shipment(@shipment)
          @shipment.shippo_reference_id = response.resource_id
          @shipment.rate_reference_id = ShippoHelper.choose_rate(response.rates, usps_service_level)
        end
        response = ShippoHelper.create_label(@shipment)
        @shipment.tracking_number = response.tracking_number
        @shipment.label_url = response.label_url
        @shipment.shipment_status = 'label_created'
      end
    end

    def usps_service_level
      if @order.country != 'US'
         usps_service_level_international
      else
        case @shipment.shipment_priority.downcase
        when nil || 'economy'
          # If under 1 lb (16oz) the shipment can go first class, > 1lb it has to go priority
          @shipment.radio.count > 1 ? 'usps_priority' : 'usps_first'
        when 'priority'
          'usps_priority'
        when 'express'
          # express shipments also get priority_processing
          @shipment.priority_processing = true
          @shipment.save
          'usps_priority_express'
        end
      end
    end

    def usps_service_level_international
      # Has to go priority mail due to it being a package and not flat
      'usps_first_class_package_international_service'
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      begin
        if !params[:tracking_number].nil?
          tracking_number = params[:tracking_number].length == 34 ? params[:tracking_number][8..-1] : params[:tracking_number]
          @shipment = Shipment.find_by_tracking_number tracking_number
          Rails.logger.debug(@shipment.attributes)
        elsif !params[:shipment_status].nil?
          @shipment = Shipment.where(shipment_status: params[:shipment_status])
        elsif !params[:id].nil?
          @shipment = Shipment.find(params[:id])
          Rails.logger.debug(@shipment.attributes)
        elsif !params[:order_id].nil?
          @shipment = Shipment.where(order_id: params[:order_id])
        else
          @shipment = Shipment.all
        end
      rescue NoMethodError => e
        api_response([], :not_found, ["Error looking up shipment #{params[:tracking_number]}"])
        raise NoShipmentFound
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:tracking_number, :ship_date, :shipment_status, :order_id, :frequencies, :priority, :label_url, :return_label_url, :shipment_priority, :shippo_reference_id, :rate_reference_id)
    end
end
