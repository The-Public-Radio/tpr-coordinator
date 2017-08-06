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
    if !params['order']['frequencies'].nil?
      frequencies = params['order']['frequencies']
    end

    @order = Order.new(order_params)

    if @order.save
      split_frequencies_into_shipments(frequencies)
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

    def split_frequencies_into_shipments(frequencies)
      frequencies_by_shipment = []

      num_radios_in_last_shipment = frequencies.count % 3
      frequencies_by_shipment << frequencies.pop(num_radios_in_last_shipment)

      (frequencies.count / 3 ).times do
        frequencies_by_shipment << frequencies.pop(3)
      end

      frequencies_by_shipment.each do |frequencies|
        shipment = Shipment.new(order_id: @order.id)
        shipment.save
        frequencies.each do |frequency|
          Radio.new(frequency: frequency, shipment_id: shipment.id).save
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:first_name, :last_name, :address, :order_source, :email, :frequencies)
    end
end
