class RadiosController < ApplicationController
  before_action :set_radio, only: [:show, :update, :destroy]

  # GET /radios
  # GET /radios.json
  def index
    if !params[:serial_number].nil?
      @radio = Radio.find_by_serial_number(params[:serial_number])
    elsif !params[:shipment_id].nil?
      @radio = Radio.where(shipment_id: params[:shipment_id])
    else
      @radio = Radio.all
    end

    if !params[:page].nil?
      paginate json: @radio, status: :ok, per_page: 1
    else
      api_response(@radio)
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

    # Default to US country code if not given
    @radio.country_code = 'US'

    # Recording assembly date. When the radio is attached to a shipment later
    # the assemble_date will differ from the objects creation date so we must
    # record it separately
    @radio.assembly_date = @radio.assembly_date.nil? ? Date.today.to_s : @radio.assembly_date

    if @radio.save
      api_response(@radio, :created)
    else
      api_response([], :unprocessable_entity, @radio.errors)
      # render json: @radio.errors, status: :unprocessable_entity
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

  def update_radio_to_boxed
    # Find radio w/ serial number
    assembled_radio = Radio.find_by_serial_number radio_params[:serial_number]
    unless assembled_radio.try(:shipment_id).nil?
      Rails.logger.info{ "User trying to update radio that is already attached to a shipment" }
      api_response([], :unprocessable_entity, 'Radio given already attached to shipment')
      raise TprError::UserError.new('Can not add shipment_id to radio already attached to shipment')
    end
    # Get the next_unboxed_radio radio in shipment
    next_unboxed_radio = Shipment.find(params[:id]).next_unboxed_radio
    # Merge assembled_radio into next_unboxed_radio
    # There's a more ruby way to do this but we'll just brute force it for now
    updated_attributes = {}
    assembled_radio.attributes.each do |k,v|
      next if v.nil?
      next unless %w(operator assembly_date pcb_version serial_number firmware_version quality_control_status).include?(k)
      Rails.logger.debug("OH NO RICK, THERE A CHANGE: #{k}")
      updated_attributes[k] = v
    end
    # Update next_unboxed_radio to be boxed
    Rails.logger.debug{ "Updating radio #{next_unboxed_radio.id} to be boxed" }
    updated_attributes['boxed'] = true
    # Destroy assembled_radio so we don't have two radios with the same serial_number
    Rails.logger.debug{ "Destroying radio #{assembled_radio.id}" }
    assembled_radio.destroy
    # Save next_unboxed_radio
    Rails.logger.debug{ "Updating radio: #{next_unboxed_radio.attributes} to: #{updated_attributes}" }
    if next_unboxed_radio.update!(updated_attributes)
      api_response(next_unboxed_radio.reload)
    else
      Rails.logger.debug{ "Radio was not able to be saved!" }
      api_response([], :unprocessable_entity, radio_assembled.errors)
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_radio
      begin
        if !radio_params[:serial_number].nil?
          @radio = Radio.find_by_serial_number(radio_params[:serial_number])
        else
          @radio = Radio.find(params[:id])
        end
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error("Radio not found: #{e}")
        api_response([], 404, e.message)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def radio_params
      Rails.logger.debug("Request params: #{params}")
      params.require(:radio).permit(:frequency, :shipment_id, :pcb_version,
        :serial_number, :operator, :boxed, :country_code, :firmware_version,
        :quality_control_status)
    end
end

module TprError
  class UserError < StandardError
  end
end
