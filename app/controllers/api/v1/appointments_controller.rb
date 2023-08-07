class Api::V1::AppointmentsController < Api::V1::ApplicationController
  include ApiResponse

  before_action :validate_availability_params, only: :availability
  before_action :set_procedure, only: :availability
  before_action :set_appointment, only: :cancellation
  before_action :require_patient, only: %i[create]
  before_action :set_create_params, only: %i[create]
  before_action :validate_start_time, only: %i[create]

  INVALID_DATE_ERROR = { "date": ["is invalid"] }
  APPOINTMENT_NOT_AVAILABLE = { "start_time": ["is not available"] }

  def index
    json_response
  end

  def availability
    available_slots = AppointmentsManager::AvailableAppointments.call(@procedure, @date)
    render json: { data: available_slots }, status: :ok
  end

  def cancellation
    @appointment.update(is_canceled: true)
    head :no_content
  end

  def create
    result = AppointmentsManager::BookAppointment.call(@procedure, @start_time, @curr_user)
    if result != AppointmentsManager::BookAppointment::FAILURE
      render json: { data: result }, status: :created
    else
      render json: { errors: APPOINTMENT_NOT_AVAILABLE }, status: :unprocessable_entity
    end
  end

  private

  def param_date
    @date = params[:date].to_date
  rescue ArgumentError
    nil
  end

  def set_appointment
    @appointment = @curr_user.appointments.find(params[:id].to_i)
  end

  def set_procedure
    @procedure = Procedure.find(params[:procedure_id].to_i)
  end

  def set_create_params
    @procedure = Procedure.find(params[:appointment][:procedure_id].to_i)
    @start_time = DateTime.parse(params[:appointment][:start_time].to_s).change(sec: 0)
  rescue ArgumentError
    nil
  end

  def validate_availability_params
    render json: { errors: INVALID_DATE_ERROR }, status: :unprocessable_entity unless param_date.present?
  end

  def validate_start_time
    render json: { errors: INVALID_DATE_ERROR }, status: :unprocessable_entity unless @start_time.present?
  end

  def appointment_book_params
    params.require(:appointment).permit(:procedure_id, :start_time)
  end

  def set_collection
    @collection = @curr_user.appointments.order("is_canceled, start_time")
  end

  def filtering_params
  end
end
