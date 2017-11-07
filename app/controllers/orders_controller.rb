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
    make_orders_with_radios(order_params) if !params['frequencies'].nil?

    if order_params[:country].nil?
      @order.country = 'US'
    end

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

    def make_orders_with_radios(working_order_params)
      @order = Order.new(working_order_params)


    end

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

      # TODO: Don't use anti-paradigms

      frequencies_by_shipment.each do |frequencies|
        controller = ShipmentsController.new
      #   controller.request = {
      #     parameters: {
      #     'shipment' => {
      #       frequencies: frequencies,
      #       order_id: @order.id
      #       }
      #     }
      #   }

        # default to economy
        shipment_priority = params['shipment_priority'].nil? ? 'economy' : params['shipment_priority']

        shipment = Shipment.create(order_id: @order.id, shipment_priority: shipment_priority )
        shipment.save
        frequencies.each do |frequency|
          Radio.create(frequency: frequency, shipment_id: shipment.id, country_code: country_code, boxed: false).save
        end

        shipment.tracking_number = controller.shipping_tracking_number(shipment)
        shipment.label_data = controller.shipping_label_data(shipment)
        shipment.shipment_status = 'label_created'
        shipment.save
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
