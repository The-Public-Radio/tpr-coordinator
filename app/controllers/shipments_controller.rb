require 'httparty'
require 'date'
require 'shippo'

class ShippoError < StandardError
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
    @shipment.save
    
    if !params['shipment']['frequencies'].nil?
      params['shipment']['frequencies'].each do |frequency| 
        Radio.create(frequency: frequency, boxed: false, shipment_id: @shipment.id).save!
      end
    end

    # Create tracking number and store base64 encoded label pdf data
    if @shipment.tracking_number.nil?
      Rails.logger.info('No tracking number provided for new shipment')
      @shipment.tracking_number = shipping_tracking_number
      @shipment.shipment_status = 'label_created'
      @shipment.label_data = shipping_label_data
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

  def shipping_tracking_number(shipment = @shipment)
    @shipping_tracking_number ||= shipping_label_creation_response(shipment).tracking_number
  end

  def shipping_label_data(shipment = @shipment)
     label_url = shipping_label_creation_response(shipment).label_url
     shipping_label = HTTParty.get(label_url).body
     @shipping_label_data ||= Base64.strict_encode64(shipping_label)
  end

  def shipping_label_creation_response(shipment)
    @shipping_label_creation_response ||= create_shipping_label(shipment)
  end

  private
    attr_accessor :shipment

    def create_shipping_label(shipment)
      @shipment = shipment
      Rails.logger.info("Creating shipping label for shipment #{shipment.id}")

      @order = Order.find(shipment.order_id)
      Rails.logger.debug("Order: #{@order}")

      Shippo::API.token = ENV['SHIPPO_TOKEN']

      shippo_options = { 
        :shipment => @order.country != 'US' ? international_shipment_options : shipment_options,
        :carrier_account => 'd2ed2a63bef746218a32e15450ece9d9',
        :servicelevel_token => @order.country != 'US' ? "usps_first_class_package_international_service" : "usps_first", 
      }
      Rails.logger.debug("Shipping label create options: #{shippo_options}")

      transaction = Shippo::Transaction.create(shippo_options)
      
      if transaction["status"] != "SUCCESS"
        Rails.logger.error(transaction.messages)
        raise ShippoError 
      end

      transaction
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
        :phone => @order.phone,
        :email => @order.email 
      }
    end

    def address_from
      {
        :name => 'Centerline Labs c/o Accelerated Assemblies',
        :company => 'Centerline Labs',
        :street1 => '725 Nicholas Blvd',
        :street2 => '',
        :city => 'Elk Grove Village',
        :state => 'IL',
        :zip => '60007',
        :country => 'US',
        :phone => ENV['FROM_ADDRESS_PHONE_NUMBER'],
        :email => 'info@thepublicrad.io' 
    }
    end

    def parcel
      shipment_size = @shipment.radio.count
      if shipment_size == 1
        {
          :length => 5,
          :width => 4,
          :height => 3,
          :distance_unit => :in,
          :weight => 12,
          :mass_unit => :oz
        }
      elsif shipment_size == 2
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
      shipment_size = @shipment.radio.count
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
      params.require(:shipment).permit(:tracking_number, :ship_date, :shipment_status, :order_id, :frequencies)
    end
end
