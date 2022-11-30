class Api::V1::ProfessionsController < Api::V1::ApplicationController
  STARTING_PAGE = 1
  PROFESSIONS_PER_PAGE = 10

  def index
    default_params = { page: STARTING_PAGE, per_page: PROFESSIONS_PER_PAGE }
    params.reverse_merge!(default_params)
    @professions = Profession.where('name LIKE ?', "%#{params[:name]}%")
                             .offset((params[:page].to_i - 1) * params[:per_page].to_i)
                             .limit(params[:per_page].to_i)
    render json: @professions, status: :ok
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
    params.permit(:page, :per_page)
  end
end
