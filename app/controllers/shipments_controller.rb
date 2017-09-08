require 'httparty'
require 'date'

class ShipstationError < StandardError
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
    # Create tracking number and store base64 encoded label pdf data
    if @shipment.tracking_number.nil?
      Rails.logger.info('No tracking number provided for new shipment')
      @shipment.tracking_number = shipstation_tracking_number
      @shipment.shipment_status = 'label_created'
      @shipment.label_data = shipstation_label_data
    end

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

  def shipstation_tracking_number
    @shipstation_tracking_number = shipstation_create_label_response_body['trackingNumber']
  end

  def shipstation_label_data
    @shipstation_tracking_number = shipstation_create_label_response_body['labelData']
  end

  def shipstation_create_label_response_body(shipment = @shipment)
    @shipstation_label ||= JSON.parse(create_shipstation_label(shipment).body)
  end

  private
    attr_accessor :shipment

    def create_shipstation_label(shipment)
      Rails.logger.info('Creating shipping label')
      order = Order.find(shipment.order_id)
      Rails.logger.debug("Order: #{order}")
      url = 'https://ssapi.shipstation.com/shipments/createlabel'

      headers = { 
        "Authorization" => "Basic #{shipstation_basic_auth_key}"
      }

      create_label_options = order.country == 'US' ? shipstation_label_options(order) : international_shipstation_label_options(order)
      Rails.logger.debug("HTTP params: url: #{url}, headers: #{headers}, body: #{create_label_options}")

      response ||= HTTParty.post(url, headers: headers, body: create_label_options)
      
      Rails.logger.debug(response)
      if !(200..299).include?(response.code)
        Rails.logger.error(response.body)
        raise ShipstationError
      end

      response
    end

    def shipstation_label_options(order)
      {
        "carrierCode": "stamps_com",
        "serviceCode": "usps_first_class_mail",
        "packageCode": "package",
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
          "name": order.name,
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
    end

    def international_shipstation_label_options(order)
      radio_count = @shipment.radio.count rescue nil
      options = shipstation_label_options(order)
      international_options = {
        "internationalOptions": {
          "contents": "gift",
          "customsItems": {
            "description": "An FM Radio",
            "quanity": "#{radio_count}",
            "value": "40",
            "harmonizedTariffCode": "85271900",
            "countryOfOrigin": "US"
          },
          "nonDelivery": "treat_as_abandoned"
        }
      }
      options.merge(international_options)
    end

    def shipstation_basic_auth_key
      Base64.strict_encode64("#{ENV['SHIPSTATION_API_KEY']}:#{ENV['SHIPSTATION_API_SECRET']}")
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      if !params[:tracking_number].nil?
        tracking_number = params[:tracking_number].length == 30 ? params[:tracking_number][8..-1] : params[:tracking_number]
        @shipment ||= Shipment.find_by_tracking_number tracking_number
        Rails.logger.debug(@shipment.attributes)
      elsif !params[:shipment_status].nil?
        @shipment ||= Shipment.where(shipment_status: params[:shipment_status])
      elsif !params[:id].nil?
        @shipment ||= Shipment.find(params[:id])
        Rails.logger.debug(@shipment.attributes)
      else
        @shipment ||= Shipment.all
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:tracking_number, :ship_date, :shipment_status, :order_id)
    end
end
