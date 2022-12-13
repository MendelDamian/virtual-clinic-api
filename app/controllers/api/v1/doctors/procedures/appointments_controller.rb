class Api::V1::Doctors::Procedures::AppointmentsController < Api::V1::ApplicationController
  before_action :set_vars, only: %i[index]

  # GET /api/v1/doctors/:doctor_id/procedures/:procedure_id/appointments/availability?date=
  def availability
  end

  private

  def set_vars
    @doctor = Doctor.find(params[:doctor_id])
    @procedure = @doctor.procedures.find(params[:procedure_id])
    @work_plan = @doctor.work_plans.find_by(day_of_week: params[:date].to_date.wday) # TODO add error handling if date is not valid
  end
end
