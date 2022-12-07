class Api::V1::DoctorsController < Api::V1::ApplicationController
  include ApiResponse

  def index
    json_response
  end

  def set_collection
    @collection = Doctor.all.order("last_name, first_name")
  end

  def filtering_params
    params.slice(:first_name, :last_name)
  end
end
