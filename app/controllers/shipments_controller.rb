class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :update, :destroy]

  # GET /shipments
  # GET /shipments.json
  def index
    @shipments = Shipment.all
  end

  # GET /shipments/1
  # GET /shipments/1.json
  def show
  end

  # POST /shipments
  # POST /shipments.json
  def create
    @shipment = Shipment.new(shipment_params)

    if @shipment.save
      render :show, status: :created, location: @shipment
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shipments/1
  # PATCH/PUT /shipments/1.json
  def update
    if @shipment.update(shipment_params)
      render :show, status: :ok, location: @shipment
    else
      render json: @shipment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shipments/1
  # DELETE /shipments/1.json
  def destroy
    @shipment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      @shipment = Shipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:tracking_number, :ship_date, :status)
    end
end
