class Api::V1::AppointmentsController < Api::V1::ApplicationController
  before_action :validate_params, only: :availability
  before_action :set_procedure, only: :availability
  before_action :set_appointment, only: :cancellation

  INVALID_DATE_ERROR = { "date": ["is invalid"] }

  def availability
    available_slots = AppointmentsManager::AvailableAppointments.call(@procedure, @date)
    render json: { data: available_slots }, status: :ok
  end

  def cancellation
    @appointment.status = :canceled
    @appointment.save!
    head :no_content
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

  def validate_params
    render json: { errors: INVALID_DATE_ERROR }, status: :unprocessable_entity unless param_date.present?
  end
end
