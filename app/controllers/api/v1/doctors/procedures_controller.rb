class Api::V1::Doctors::ProceduresController < Api::V1::ApplicationController
  include ApiResponse

  # GET /api/v1/doctors/:doctor_id/procedures/?name=
  def index
    json_response
  end

  def set_collection
    @collection = Doctor.find(params[:doctor_id]).procedures.order("name")
  end

  def filtering_params
    params.slice(:name)
  end
end

