class Api::V1::Procedures::AppointmentsController < Api::V1::ApplicationController
  before_action :date_param_valid?, only: [:availability]
  before_action :set_procedure, only: %i[availability]

  INVALID_DATE_ERROR = { "date": ["is invalid"] }

  # GET /api/v1/procedures/:procedure_id/appointments/availability?date=
  def availability
    available_slots = AppointmentsService.available_slots(@procedure, @date)
    render json: { data: available_slots }, status: :ok
  end

  private

  def set_procedure
    @procedure = Procedure.find(params[:procedure_id].to_i)
  end

  def param_date
    @date = params[:date].to_date
  rescue ArgumentError
    nil
  end

  def date_param_valid?
    render json: { errors: INVALID_DATE_ERROR }, status: :unprocessable_entity unless param_date.present?
  end
end
