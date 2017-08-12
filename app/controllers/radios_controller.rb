class RadiosController < ApplicationController
  before_action :set_radio, only: [:show, :update, :destroy]

  # GET /radios
  # GET /radios.json
  def index
    @radios = Radio.where(shipment_id: params[:shipment_id])
    if !params[:page].nil?
      paginate json: @radios, status: :ok, per_page: 1

      # paginated_api_response(@radios)
    else
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
      api_response(@radio, :created)
    else
      render json: @radio.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /radios/1
  # PATCH/PUT /radios/1.json
  def update
    if @radio.update(radio_params)
      render json: :show, status: :ok
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
      params.require(:radio).permit(:frequency, :shipment_id, :pcb_version, :serial_number, :operator, :boxed)
    end
end
