class Api::V1::Procedures::AppointmentsController < Api::V1::ApplicationController
  before_action :date_param_valid?, only: [:availability]
  before_action :set_vars, only: %i[availability]

  INVALID_DATE_ERROR = { "date": ["is invalid"] }

  # GET /api/v1/procedures/:procedure_id/appointments/availability?date=
  def availability
    # While iterating I will use number of minutes from the beginning of the day.

    # TODO: move this to an external service to do not bloat the controller.
    time_curr = minutes(@work_plan.work_hour_start)
    time_end = minutes(@work_plan.work_hour_end)

    available_slots = []
    while time_curr + @procedure.needed_time_min <= time_end
      skip = false
      @appointments.each do |appointment|
        if between?(time_curr + @procedure.needed_time_min, appointment)
          skip = true
          time_curr = datetime_to_minutes(appointment.start_time) + appointment.procedure.needed_time_min
          break
        end
      end

      next if skip

      available_slots << Time.parse("#{time_curr / 60}:#{time_curr % 60}").strftime("%H:%M")
      time_curr += Procedure::SHORTEST_PROCEDURE_TIME
    end

    render json: { data: available_slots }, status: :ok
  end

  private

  def between?(time_curr, appointment)
    time_curr > datetime_to_minutes(appointment.start_time) &&
      time_curr < datetime_to_minutes(appointment.start_time) + appointment.procedure.needed_time_min
  end

  def datetime_to_minutes(datetime)
    datetime.hour * 60 + datetime.min
  end

  def minutes(hours)
    hours * 60
  end

  def set_vars
    @procedure = Procedure.find(params[:procedure_id].to_i)
    @doctor = @procedure.doctor
    @work_plan = @doctor.work_plans.find_by(day_of_week: @date.wday) # FIXME
    @appointments = @doctor.appointments.filter_by_start_time(@date)
  end

  def param_date
    @date = params[:date].to_date
  rescue ArgumentError
    nil
  end

  def date_param_valid?
    render json: { errors: INVALID_DATE_ERROR }, status: :unprocessable_entity unless param_date.present?
  end
end
