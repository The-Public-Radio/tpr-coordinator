require 'httparty'
require 'date'
require 'shippo'

class ShippoError < StandardError
end

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

  def shipping_tracking_number(shipment = @shipment)
    @shipping_tracking_number ||= shipping_label_creation_response(shipment).tracking_number
  end

  def shipping_label_url(shipment = @shipment)
    @shipping_label_url ||= shipping_label_creation_response(shipment).label_url
  end

  def shipping_label_creation_response(shipment)
    @shipping_label_creation_response ||= create_shipping_label(shipment)
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
      processable_order_source =  %w{other kickstarter squarespace uncommon_goods WFAE LGA WBEZ KUER}.include?(s.order.order_source)

      has_radios && processable_order_source
    end[0]

    # Return top of the queue
    api_response(@shipment)
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
    attr_accessor :shipment, :shipment_size
   
    class RadioInvalid < StandardError
    end

    def set_up_default_shipment(frequencies = params['shipment']['frequencies'], shipment_priority = params['shipment']['shipment_priority'].downcase)
      if !@order.nil?
        find_order(@shipment)
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
      @shipment.shipment_priority = shipment_priority.nil? ? 'economy' : shipment_priority

      # Create tracking number and label_url
      if @shipment.tracking_number.nil?
        Rails.logger.info('No tracking number provided for new shipment')
        @shipment.tracking_number = shipping_tracking_number
        @shipment.shipment_status = 'label_created'
        @shipment.label_url = shipping_label_url
      end
    end

    def find_order(shipment)
      @order = Order.find(shipment.order_id)
    end

    def create_shipping_label(shipment)
      find_order(shipment)
      Rails.logger.info("Creating shipping label for shipment #{shipment.id}")

      Shippo::API.token = ENV['SHIPPO_TOKEN']

      shippo_options = {
        :shipment => @order.country != 'US' ? international_shipment_options : shipment_options,
        :carrier_account => 'd2ed2a63bef746218a32e15450ece9d9',
        :servicelevel_token => usps_service_level,
      }
      Rails.logger.debug("Shipping label create options: #{shippo_options}")

      begin
        transaction = Shippo::Transaction.create(shippo_options)
      rescue RestClient::BadRequest => e
        Rails.logger.error("Bad request to the Shippo api: #{e}")
        Rails.logger.error("Returned transaction: #{transaction}")
      end

      if transaction["status"] != "SUCCESS"
        Rails.logger.error(transaction.messages)
        raise ShippoError
      end

      transaction
    end

    def usps_service_level
      if @order.country != 'US'
         usps_service_level_international
      else
        case @shipment.shipment_priority.downcase
        when nil || 'economy'
          # If under 1 lb (16oz) the shipment can go first class, > 1lb it has to go priority
          @shipment_size > 1 ? 'usps_priority' : 'usps_first'
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

    def shipment_options
      {
        :address_from => address_from,
        :address_to => address_to,
        :parcels => parcel
      }
    end

    def international_shipment_options
      {
        address_from: address_from,
        address_to: address_to,
        parcels: parcel,
        customs_declaration: customs_declaration
      }
    end

    def address_to
      {
        :name => @order.name,
        :company => '',
        :street1 => @order.street_address_1,
        :street2 => @order.street_address_2,
        :city => @order.city,
        :state => @order.state,
        :zip => @order.postal_code,
        :country => @order.country,
        :phone => @order.phone.nil? ? '' : @order.phone,
        :email => @order.email
      }
    end

    def address_from
      {
        :name => 'Centerline Labs',
        :company => '',
        :street1 => '814 Lincoln Pl',
        :street2 => '#2',
        :city => 'Brooklyn',
        :state => 'NY',
        :zip => '11216',
        :country => 'US',
        :phone => ENV['FROM_ADDRESS_PHONE_NUMBER'],
        :email => 'info@thepublicrad.io'
    }
    end

    def shipment_size
      @shipment_size ||= @shipment.radio.count
    end

    def parcel
      if shipment_size == 2
        {
          :length => 6,
          :width => 5,
          :height => 4,
          :distance_unit => :in,
          :weight => 1.75,
          :mass_unit => :lb
        }
      elsif shipment_size == 3
        {
          :length => 9,
          :width => 5,
          :height => 4,
          :distance_unit => :in,
          :weight => 2.60,
          :mass_unit => :lb
        }
      else
        {
          :length => 5,
          :width => 4,
          :height => 3,
          :distance_unit => :in,
          :weight => 12,
          :mass_unit => :oz
        }
      end
    end

    def customs_declaration
      customs_declaration_options = {
        :contents_type => "MERCHANDISE",
        :contents_explanation => "Single station FM radio",
        :non_delivery_option => "ABANDON",
        :certify => true,
        :certify_signer => "Spencer Wright",
        :items => [customs_item]
      }

      Shippo::CustomsDeclaration.create(customs_declaration_options)
    end

    def customs_item
      if shipment_size == 1
        {
          :description => "Single station FM radio",
          :quantity => 1,
          :net_weight => "12",
          :mass_unit => "oz",
          :value_amount => "40",
          :value_currency => "USD",
          :origin_country => "US"
        }
      elsif shipment_size == 2
        {
          :description => "Single station FM radio",
          :quantity => 2,
          :net_weight => "1.75",
          :mass_unit => "lb",
          :value_amount => "80",
          :value_currency => "USD",
          :origin_country => "US"
        }
      elsif shipment_size == 3
        {
          :description => "Single station FM radio",
          :quantity => 3,
          :net_weight => "2.60",
          :mass_unit => "lb",
          :value_amount => "120",
          :value_currency => "USD",
          :origin_country => "US"
        }
      end
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
      params.require(:shipment).permit(:tracking_number, :ship_date, :shipment_status, :order_id, :frequencies, :priority, :label_url, :shipment_priority)
    end
end
