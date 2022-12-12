class Api::V1::WorkPlansController < Api::V1::ApplicationController
  include ApiResponse

  # GET /api/v1/work_plans
  def index
    json_response
  end

  # GET /api/v1/work_plans/1
  def show
    render json: @work_plan
  end

  # POST /api/v1/work_plans
  def create
    return head :unauthorized unless @curr_user.account_type_doctor?

    @work_plan = @curr_user.work_plans.new(work_plan_params)
    if @work_plan.save
      render json: { data: @work_plan }, status: :created
    else
      render json: { errors: @work_plan.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/work_plans/1
  def update
    if @work_plan.update(work_plan_params)
      render json: @work_plan
    else
      render json: @work_plan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/work_plans/1
  def destroy
    return head :unauthorized unless @curr_user.account_type_doctor?
    @work_plan.destroy
  end

  def set_collection
    @collection = WorkPlan.all
  end

  def filtering_params
    params.slice(:day_of_week)
  end

  private

    # Only allow a list of trusted parameters through.
  def work_plan_params
    params.require(:work_plan).permit(:day_of_week, :work_hour_start, :work_hour_end)
  end

end
