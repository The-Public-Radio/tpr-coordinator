class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :update, :destroy]

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

    if @shipment.save
      api_response(@shipment)
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

  private
    attr_accessor :shipment
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
