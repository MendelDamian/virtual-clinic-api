class Api::V1::ProceduresController < Api::V1::ApplicationController
  include ApiResponse
  before_action :require_doctor, only: %i[create update destroy]
  before_action :set_procedure, only: %i[update destroy]

  # GET /api/v1/procedures/?name=
  def index
    json_response
  end

  # POST /api/v1/procedures
  def create
    @procedure = @curr_user.procedures.new(procedure_params)
    if @procedure.save
      render json: { data: @procedure }, status: :created
    else
      render json: { errors: @procedure.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/procedures/ID OF PROCEDURE
  def update
    @procedure.update!(procedure_params)
    render json: { data: @procedure }, status: :ok
  rescue ActiveRecord::RecordInvalid
    render json: { errors: @procedure.errors }, status: :unprocessable_entity
  end

  # DELETE /api/v1/procedures/ID OF PROCEDURE
  def destroy
    @procedure.destroy!
    head :no_content
  end

  def set_collection
    @collection = Procedure.includes(:doctor).order(:name)
  end

  def filtering_params
    params.slice(:name)
  end

  private

  def set_procedure
    @procedure = @curr_user.procedures.find(params[:id])
  end

  def procedure_params
    params.require(:procedure).permit(:name, :needed_time_min)
  end
end
