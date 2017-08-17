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

    # Default to unboxed radios
    @radio.boxed = @radio.boxed.nil? ? false : @radio.boxed

    # Recording assembly date. When the radio is attached to a shipment later 
    # the assemble_date will differ from the objects creation date so we must
    # record it separately
    @radio.assembly_date = @radio.assembly_date.nil? ? Date.today.to_s : @radio.assembly_date

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
      api_response(@radio)
    else
      api_response([], :unprocessable_entity, @radio.errors)
    end
  end

  # DELETE /radios/1
  # DELETE /radios/1.json
  def destroy
    @radio.destroy
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_radio
      if !params[:serial_number].nil?
        @radio = Radio.find_by_serial_number(params[:serial_number])
      else
        @radio = Radio.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def radio_params
      params.require(:radio).permit(:frequency, :shipment_id, :pcb_version, :serial_number, :operator, :boxed)
    end
end
