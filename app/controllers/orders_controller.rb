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
      split_frequencies_into_shipments(frequency_hash) unless frequency_hash.nil?
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
    @shipment_priority = working_order_params.delete(:shipment_priority)
    @order = Order.new(working_order_params)
    @order.conutry = 'US' if @working_order_params[:country].nil?
    unless @order.save
      Rails.logger.error("Order is invalid: #{@order.errors.messages}")
      raise OrderInvalid(@order.errors.messages)
    end

    split_frequencies_into_shipments(frequency_hash)
  end

  private

    def split_frequencies_into_shipments(frequency_hash)
      frequency_hash.each do |country_code,frequencies|
        frequencies_by_shipment = []

        if frequencies.count > 3
          num_radios_in_last_shipment = frequencies.count % 3
          frequencies_by_shipment << frequencies.pop(num_radios_in_last_shipment)

          (frequencies.count / 3 ).times do
            frequencies_by_shipment << frequencies.pop(3)
          end
        else
          frequencies_by_shipment << frequencies
        end

        shipment_priority = @shipment_priority.nil? ? params['shipment_priority'] : @shipment_priority

        frequencies_by_shipment.each do |frequencies|
          ShipmentsController.new.create_shipment_from_order(@order, frequencies, shipment_priority)
        end
      end
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
