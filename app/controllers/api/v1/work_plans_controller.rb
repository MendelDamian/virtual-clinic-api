class Api::V1::WorkPlansController < Api::V1::ApplicationController
  before_action :require_doctor, only: %i[create update destroy]
  before_action :set_work_plan, only: %i[update destroy]

  # POST /api/v1/work_plans
  def create
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
      render json: { data: @work_plan }, status: :ok
    else
      render json: { errors: @work_plan.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/work_plans/1
  def destroy
    @work_plan.destroy!
    head :no_content
  end

  private
  
  def set_work_plan
    @work_plan = @curr_user.work_plans.find(params[:id])
  end

  def work_plan_params
    params.require(:work_plan).permit(:day_of_week, :work_hour_start, :work_hour_end)
  end
end
