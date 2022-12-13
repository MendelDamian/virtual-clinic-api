class Api::V1::ProfessionsController < Api::V1::ApplicationController
  include ApiResponse
  before_action :require_doctor, only: %i[create]

  def index
    json_response
  end

  def create
    @profession = Profession.new(profession_params)
    if @profession.save
      render json: { data: @profession }, status: :created
    else
      render json: { errors: @profession.errors }, status: :unprocessable_entity
    end
  end

  private

  def profession_params
    params.require(:profession).permit(:name)
  end

  def set_collection
    @collection = Profession.all
  end

  def filtering_params
    params.slice(:name)
  end
end
