class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all
    api_response(@orders)
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    frequency_hash = params['frequencies'] if !params['frequencies'].nil?

    @order = Order.new(order_params)

    if @order.save
      make_shipments_for_order(frequency_hash) unless frequency_hash.nil?
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

  private

    def make_shipments_for_order(frequency_hash)
      frequency_hash.each do |country_code,frequencies|
        split_frequencies_into_shipments(country_code,frequencies) if !params['frequencies'].nil?
      end
    end

    def split_frequencies_into_shipments(country_code,frequencies)
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

      frequencies_by_shipment.each do |frequencies|
        shipment = Shipment.new(order_id: @order.id)
        shipment.save
        frequencies.each do |frequency|
          Radio.new(frequency: frequency, shipment_id: shipment.id, country_code: country_code).save
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:name, :order_source, :email, :frequencies, :street_address_1, :street_address_2, :city, :state, :postal_code, :country, :phone)
    end
end
