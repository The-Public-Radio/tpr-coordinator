class RadiosController < ApplicationController
  before_action :set_radio, only: [:show, :update, :destroy]

  # GET /radios
  # GET /radios.json
  def index
    if params[:page].nil?
      @radios = Radio.where(shipment_id: params[:shipment_id])
      api_response(@radios)
    end
  end

  # GET /radios/1
  # GET /radios/1.json
  def show
    api_response(@radio)
  end

  # POST /radios
  # POST /radios.json
  def create
    @radio = Radio.new(radio_params)

    if @radio.save
      render json: :show, status: :created, location: @radio
    else
      render json: @radio.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /radios/1
  # PATCH/PUT /radios/1.json
  def update
    if @radio.update(radio_params)
      render json: :show, status: :ok, location: @radio
    else
      render json: @radio.errors, status: :unprocessable_entity
    end
  end

  # DELETE /radios/1
  # DELETE /radios/1.json
  def destroy
    @radio.destroy
  end

  private
    def shipment_radios
      
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_radio
      @radio = Radio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def radio_params
      params.require(:radio).permit(:frequency)
    end
end
