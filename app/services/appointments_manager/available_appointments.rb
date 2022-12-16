class AppointmentsManager::AvailableAppointments < ::ApplicationService
  attr_reader :procedure, :date

  def initialize(procedure, date)
    @procedure = procedure
    @date = date
  end

  def call
    @doctor = @procedure.doctor
    @work_plan = @doctor.work_plans.find_by!(day_of_week: @date.wday)
    @appointments = @doctor.appointments.filter_by_start_time(@date)
    @duration = @procedure.needed_time_min

    get_available_slots
  end

  private

  def get_available_slots
    time_curr = @work_plan.work_hour_start * 60
    time_end = @work_plan.work_hour_end * 60

    available_slots = []
    while time_curr + @duration <= time_end
      skip = false
      @appointments.each do |appointment|
        if between?(time_curr + @duration, appointment)
          skip = true
          time_curr = minutes(appointment.start_time) + appointment.duration
          break
        end
      end

      next if skip

      available_slots << format_time(time_curr)
      time_curr += Procedure::SHORTEST_PROCEDURE_TIME
    end

    available_slots
  end

  def format_time(time)
    Time.parse("#{time / 60}:#{time % 60}").strftime("%H:%M")
  end

  def minutes(datetime)
    datetime.hour * 60 + datetime.min
  end

  def between?(time_curr, appointment)
    minutes(appointment.start_time) < time_curr < minutes(appointment.start_time) + appointment.duration
  end
end
