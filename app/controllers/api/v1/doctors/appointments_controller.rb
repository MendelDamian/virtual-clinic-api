class Api::V1::Doctors::AppointmentsController < Api::V1::ApplicationController
  include ApiResponse

  # GET /api/v1/doctors/:doctor_id/appointments
  def index
    json_response
  end

  def set_collection
    @collection = Doctor.find(params[:doctor_id]).appointments
  end

  def filtering_params
  end
end

