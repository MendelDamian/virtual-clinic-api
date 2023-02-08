class Api::V1::AppointmentsController < Api::V1::ApplicationController
  before_action :validate_params, only: %i[availability]
  before_action :set_procedure, only: %i[availability]

  INVALID_DATE_ERROR = { "date": ["is invalid"] }
  def availability
    available_slots = AppointmentsManager::AvailableAppointments.call(@procedure, @date)
    render json: { data: available_slots }, status: :ok
  end

  def create
    @appointment = @curr_user.appointments.new(appointment_book_params)
    if @appointment.save
      render json: { data: @appointment }, status: :created
    else
      render json: { errors: @appointment.errors }, status: :unprocessable_entity
    end
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

  def appointment_book_params
    params.require(:appointment).permit(:doctor_id, :procedure_id, :start_time)
  end
end
