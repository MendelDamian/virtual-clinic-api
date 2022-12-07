class Api::V1::ProceduresController < Api::V1::ApplicationController
  include ApiResponse

  # GET /api/v1/procedures/?name=
  def index
    json_response
  end
  def set_collection
    @collection = @curr_user.procedures.all
  end
  def filtering_params
    params.slice(:name)
  end
  # POST /api/v1/procedures
  def create
    return head :unauthorized unless @curr_user.account_type_doctor?

    @procedure = @curr_user.procedures.new(procedure_params)
    if @procedure.save
      render json: { data: @procedure }, status: :created
    else
      render json: { errors: @procedure.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/procedures/ID OF PROCEDURE
  def update
    return head :unauthorized unless @curr_user.account_type_doctor?
    @procedure = @curr_user.procedures.find(params[:id])
    @procedure.update!(procedure_params)
    render json: { data: @procedure }, status: :ok
  end
  # DELETE /api/v1/procedures/ID OF PROCEDURE
  def destroy
    return head :unauthorized unless @curr_user.account_type_doctor?
    @procedure = @curr_user.procedures.find(params[:id])
    @procedure.destroy!
    head :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  # Only allow a list of trusted parameters through.
  def procedure_params
    params.require(:procedure).permit(:name, :needed_time_min)
  end
end
