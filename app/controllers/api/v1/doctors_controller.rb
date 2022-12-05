class Api::V1::DoctorsController < Api::V1::ApplicationController
  def professions
    @doctor = Doctor.find(params[:id])
    render json: { data: @doctor.professions }, status: :ok
  end
end
