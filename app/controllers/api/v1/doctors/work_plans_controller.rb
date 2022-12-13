class Api::V1::Doctors::WorkPlansController < Api::V1::ApplicationController
  include ApiResponse

  def index
    json_response
  end

  def set_collection
    @collection = Doctor.find(params[:doctor_id]).work_plans.order(:day_of_week)
  end

  def filtering_params
  end
end
