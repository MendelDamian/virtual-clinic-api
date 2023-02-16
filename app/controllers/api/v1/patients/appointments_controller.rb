class Api::V1::Patients::AppointmentsController < Api::V1::ApplicationController
  include ApiResponse

  # GET /api/v1/patients/:patient_id/appointments
  def index
    json_response
  end

  def set_collection
    @collection = Patient.find(params[:patient_id]).appointments
  end

  def filtering_params
  end
end

