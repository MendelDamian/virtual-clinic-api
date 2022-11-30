class Api::V1::ProfessionsController < Api::V1::ApplicationController
  def index
    @professions = Profession.all
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
  end
end
