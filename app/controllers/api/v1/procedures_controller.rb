class Api::V1::ProceduresController < ::ApplicationController
  before_action :set_procedure, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  # GET /api/v1/procedures
  def index
    if current_user.account_type_doctor?
      @procedures = current_user.procedures.all
      render json: @procedures
    else
      render json: { error: 'Log in as doctor to see your procedures list' }, status: :unauthorized
    end
  end

  # GET /api/v1/procedures/1
  def show
    render json: @procedure
  end

  # POST /api/v1/procedures
  def create
    if current_user.account_type_doctor?
      @procedure = current_user.procedures.new(procedure_params)
      if @procedure.save
        render json: @procedure, status: :created
      else
        render json: @procedure.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Only doctors can create procedures' }, status: :unauthorized
    end
  end

  # PATCH/PUT /api/v1/procedures/[ID OF PROCEDURE]
  def update
    unless @procedure.presence
      render json: { error: 'Procedure not found' }, status: :not_found
    end
    unless current_user.account_type_doctor?
      render json: { error: 'Only doctors can edit procedures' }, status: :unauthorized
    end
    if @procedure.update(procedure_params)
      render json: @procedure
    else
      render json: @procedure.errors, status: :unprocessable_entity
    end
  end
  # DELETE /api/v1/procedures/[ID OF PROCEDURE]
  def destroy
    if(@procedure.presence)
      if @procedure.destroy
        head :ok
      end
    else
      render json:{ error: 'There is no such procedure for that doctor' }, status: :not_found
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_procedure
    @procedure = current_user.procedures.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def procedure_params
    params.require(:procedure).permit(:name, :needed_time)
  end
end
