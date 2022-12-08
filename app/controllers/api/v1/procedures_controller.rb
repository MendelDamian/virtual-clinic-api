class Api::V1::ProceduresController < Api::V1::ApplicationController
  include ApiResponse

  # GET /api/v1/procedures/?name=
  def index
    json_response
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
    @curr_user.procedures.find(params[:id]).destroy!
    head :no_content
  end

  def set_collection
    @collection = Procedure.all.order(:name)
  end

  def filtering_params
    params.slice(:name)
  end

  private

  def procedure_params
    params.require(:procedure).permit(:name, :needed_time_min)
  end
end
