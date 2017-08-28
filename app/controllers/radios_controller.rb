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
    # if radio_params[:boxed]
    #   update_radio_to_boxed
    # elsif !radio_params[:boxed]
    #   update_radio_to_unboxed
    # else
      if @radio.update(radio_params)
        api_response(@radio)
      else
        api_response([], :unprocessable_entity, @radio.errors)
      end
    # end
  end

  # DELETE /radios/1
  # DELETE /radios/1.json
  def destroy
    @radio.destroy
  end

  def update_radio_to_boxed
    shipment = Shipment.find(params[:id])
    next_unboxed_radio = shipment.next_unboxed_radio
    Rails.logger.debug{ "Shipment: #{shipment}" }

    # Find radio_assembed record w/ serial number
    radio_assembled = Radio.find_by_serial_number radio_params[:serial_number]
    # Get the next_unboxed_radio frequency in shipment
    radio_assembled.frequency = next_unboxed_radio.frequency
    # Update radio_assembed with shipment_id and to be boxed
    radio_assembled.shipment_id = shipment.id
    radio_assembled.boxed = true
    # Save radio_assembed
    Rails.logger.debug{ "Assembled Radio: #{radio_assembled}" }

    if radio_assembled.save!
      api_response(radio_assembled)
      # Destroy stub radio / next_unboxed_radio
      Rails.logger.debug{ "Next_unboxed_radio: #{next_unboxed_radio}" }
      next_unboxed_radio.destroy
    else
      api_response([], :unprocessable_entity, radio_assembled.errors)
    end
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
      Rails.logger.debug("Request params: #{params}")
      params.require(:radio).permit(:frequency, :shipment_id, :pcb_version, :serial_number, :operator, :boxed, :country_code)
    end
end
