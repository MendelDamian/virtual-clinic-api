class Api::V1::ProceduresController < ApplicationController
  before_action :set_api_v1_procedure, only: [:show, :update, :destroy]

  # GET /api/v1/procedures
  def index
    @procedures = Procedure.all

    render json: @procedures
  end

  # GET /api/v1/procedures/1
  def show
    render json: @procedure
  end

  # POST /api/v1/procedures
  def create
    @procedure = Procedure.new(api_v1_procedure_params)

    if @procedure.save
      render json: @procedure, status: :created
    else
      render json: @procedure.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/procedures/1
  def update
    if @procedure.update(api_v1_procedure_params)
      render json: @procedure
    else
      render json: @procedure.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/procedures/1
  def destroy
    @procedure.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_procedure
      @procedure = Procedure.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_v1_procedure_params
      params.require(:procedure).permit(:name, :needed_time)
    end
end
