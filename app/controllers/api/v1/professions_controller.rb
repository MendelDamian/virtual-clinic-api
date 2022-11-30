class Api::V1::ProfessionsController < Api::V1::ApplicationController
  STARTING_PAGE = 1
  PROFESSIONS_PER_PAGE = 10

  def index
    # Validate pagination params.
    if params[:page].to_i < STARTING_PAGE || params[:per_page].to_i < 1
      render json: { error: 'Invalid page or per_page' }, status: :bad_request
      return
    end

    default_pagination_params = { page: STARTING_PAGE, per_page: PROFESSIONS_PER_PAGE }
    params.reverse_merge!(default_pagination_params)
    @professions = Profession.where('name LIKE ?', "%#{params[:name]}%")
                             .offset((params[:page].to_i - 1) * params[:per_page].to_i)
                             .limit(params[:per_page].to_i)
    render json: @professions, status: :ok
  end

  # Display all professions for a doctor.
  # GET /api/v1/professions/doctor/:doctor_id
  def doctor
    @doctor = Doctor.where(id: params[:doctor_id]).first
    if @doctor
      render json: @doctor.professions, status: :ok
    else
      render json: { error: 'Doctor not found' }, status: :not_found
    end
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
end
