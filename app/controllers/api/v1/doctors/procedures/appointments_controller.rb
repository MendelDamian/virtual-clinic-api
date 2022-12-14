class Api::V1::Doctors::Procedures::AppointmentsController < Api::V1::ApplicationController
  before_action :date_param_valid?, only: [:availability]
  before_action :set_vars, only: %i[availability]

  INVALID_DATE_ERROR = { "date": ["is invalid"] }

  # GET /api/v1/doctors/:doctor_id/procedures/:procedure_id/appointments/availability?date=
  def availability
    render json: { data: [] }, status: :ok
  end

  private

  def set_vars
    @doctor = Doctor.find(params[:doctor_id].to_i)
    @procedure = @doctor.procedures.find(params[:procedure_id].to_i)
    @work_plan = @doctor.work_plans.find_by(day_of_week: params[:date].to_date.wday)
  end

  def param_date
    params[:date].to_date
  rescue ArgumentError
    nil
  end

  def date_param_valid?
    render json: { errors: INVALID_DATE_ERROR }, status: :unprocessable_entity unless param_date.present?
  end
end
