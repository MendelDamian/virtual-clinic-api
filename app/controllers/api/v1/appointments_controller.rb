class Api::V1::AppointmentsController < Api::V1::ApplicationController
  include ApiResponse

  before_action :validate_params, only: %i[availability]
  before_action :set_procedure, only: %i[availability]

  INVALID_DATE_ERROR = { "date": ["is invalid"] }

  def index
    json_response
  end

  def availability
    available_slots = AppointmentsManager::AvailableAppointments.call(@procedure, @date)
    render json: { data: available_slots }, status: :ok
  end

  private

  def param_date
    @date = params[:date].to_date
  rescue ArgumentError
    nil
  end

  def set_procedure
    @procedure = Procedure.find(params[:procedure_id].to_i)
  end

  def validate_params
    render json: { errors: INVALID_DATE_ERROR }, status: :unprocessable_entity unless param_date.present?
  end

  def set_collection
    @collection = @curr_user.appointments.order("status, start_time")
  end

  def filtering_params
  end
end
