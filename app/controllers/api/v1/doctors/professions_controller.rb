class Api::V1::Doctors::ProfessionsController < Api::V1::ApplicationController
  include ApiResponse

  def index
    json_response
  end

  def set_collection
    @collection = Doctor.find(params[:doctor_id]).professions.order("name")
  end

  def filtering_params
    params.slice(:name)
  end
end