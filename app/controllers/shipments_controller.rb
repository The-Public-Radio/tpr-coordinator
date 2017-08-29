require 'httparty'
require 'date'

class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :update, :destroy, :next_unboxed_radio]

  # GET /shipments
  # GET /shipments.json
  def index
    set_shipment
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
    @shipment.tracking_number = shipstation_tracking_number if @shipment.tracking_number.nil?

    if @shipment.save
      api_response(@shipment, :created)
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shipments/1
  # PATCH/PUT /shipments/1.json
  def update
    if @shipment.update(shipment_params)
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

  private
    attr_accessor :shipment

    def shipstation_tracking_number
      @shipstation_tracking_number = create_shipstation_label['trackingNumber']
    end

    def create_shipstation_label  
      order = Order.find(@shipment.order_id)
      Rails.logger.debug("Order: #{order}")
      url = 'https://ssapi.shipstation.com/shipments/createlabel'

      headers = { 
        "Authorization" => "Basic #{shipstation_basic_auth_key}"
      }

      create_label_options = {
        "carrierCode": "stamps_com",
        "serviceCode": "usps_first_class_mail",
        "packageCode": "1",
        "shipDate": Date.today.to_s,
        "weight": {
          "value": 12,
          "units": "ounces"
        },
        "dimensions": {  
          "units": "inches",
          "length": 5.0,
          "width": 4.0,
          "height": 3.0
        },
        "shipFrom": {
          "name": "Centerline Labs c/o Accelerated Assemblies",
          "street1": "725 Nicholas Blvd",
          "city": "Elk Grove Village",
          "state": "IL",
          "postalCode": "60007",
          "country": "US",
          "residential": false
        },
        "shipTo": {
          "name": "#{order.first_name} #{order.last_name.nil? ? '' : order.last_name}",
          "company": '',
          "street1": order.street_address_1,
          "street2": order.street_address_2,
          "city": order.city,
          "state": order.state,
          "postalCode": order.postal_code,
          "country": order.country,
          "residential": true
        }
      }
      Rails.logger.debug("HTTP params: url: #{url}, headers: #{headers}, body: #{create_label_options}")

      response = HTTParty.post(url, headers: headers, body: create_label_options)
      Rails.logger.debug(response)
      # handle_shipstation_response(response)
      JSON.parse(response.body)
    end

    def shipstation_basic_auth_key
      Base64.strict_encode64("#{ENV['SHIPSTATION_API_KEY']}:#{ENV['SHIPSTATION_API_SECRET']}")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      if !params[:tracking_number].nil?
        @shipment ||= Shipment.find_by_tracking_number(params[:tracking_number])
      elsif !params[:id].nil?
        @shipment ||= Shipment.find(params[:id])
      else
        @shipment ||= Shipment.all
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:tracking_number, :ship_date, :shipment_status, :order_id)
    end
end
