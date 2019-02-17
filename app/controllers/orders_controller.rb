class OrderInvalid < StandardError
end

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    if !params[:order_source].nil?
      @orders = Order.where(order_source: params['order_source'])
    else
      @orders = Order.all
    end
    api_response(@orders)
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = Order.new(order_params)

    if order_params[:country].nil?
      @order.country = 'US'
    end

    frequency_hash = params['frequencies']

    if @order.save
      split_frequencies_into_shipments(frequency_hash, params['shipment_priority']) unless frequency_hash.nil?
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  def make_queue_order_with_radios(working_order_params)
    @working_order_params = working_order_params
    frequency_hash = working_order_params.delete(:frequencies)
    shipment_priority = working_order_params.delete(:shipment_priority)
    @order = Order.new(working_order_params)
    @order.conutry = 'US' if @working_order_params[:country].nil?
    unless @order.save
      Rails.logger.error("Order is invalid: #{@order.errors.messages}")
      raise OrderInvalid(@order.errors.messages)
    end

    split_frequencies_into_shipments(frequency_hash, shipment_priority)
  end

  private

    def split_frequencies_into_shipments(frequency_hash, shipment_priority)
      radios = TaskHelper.convert_radio_map_to_array(frequency_hash)
      while radios.count > 3
        ShipmentsController.new.create_shipment_from_order(@order, radios.pop(3), shipment_priority)
      end
      ShipmentsController.new.create_shipment_from_order(@order, radios, shipment_priority)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:name, :order_source, :email, :frequencies, :street_address_1, :street_address_2, :city, :state, :postal_code, :country, :phone, :invoiced, :reference_number, :comments, :notified)
    end
end
