class Api::V1::ProfessionsController < Api::V1::ApplicationController
  include ApiResponse

  def index
    json_response
  end

  # Display all professions for a doctor.
  # GET /api/v1/professions/doctor/:doctor_id
  def doctor
    @doctor = Doctor.find(params[:doctor_id])
    render json: @doctor.professions, status: :ok
  end

  def create
    @profession = Profession.new(profession_params)
    if @profession.save
      render json: @profession, status: :created
    else
      render json: @profession.errors, status: :unprocessable_entity
    end
  end

  private

  def profession_params
    params.require(:profession).permit(:name)
  end

  def set_collection
    Profession
  end

  def filtering_params
    params.slice(:name)
  end
end
