class AppointmentsManager::AvailableAppointments < ::ApplicationService
  attr_reader :procedure, :date, :doctor

  def initialize(procedure, date)
    @procedure = procedure
    @date = date
    @doctor = procedure.doctor
  end

  def call
    appointments = doctor.appointments.filter_by_start_time(date).not_canceled
    work_plans = doctor.work_plans.where(day_of_week: date.wday).order(:work_hour_start)

    available_slots = []
    work_plans.each do |work_plan|
      time_curr = work_plan.work_hour_start * 60
      time_end = work_plan.work_hour_end * 60


      while time_curr + procedure.needed_time_min <= time_end
        skip = false
        appointments.each do |appointment|
          if between?(time_curr + procedure.needed_time_min, appointment)
            skip = true
            time_curr = minutes(appointment.start_time) + appointment.needed_time_min
            break
          end
        end

        next if skip

        available_slots << format_time(time_curr)
        time_curr += Procedure::SHORTEST_PROCEDURE_TIME
      end
    end

    available_slots
  end

  private

  def format_time(time)
    Time.parse("#{time / 60}:#{time % 60}").strftime("%H:%M")
  end

  def minutes(datetime)
    datetime.hour * 60 + datetime.min
  end

  def between?(time_curr, appointment)
    time_curr.between?(minutes(appointment.start_time), minutes(appointment.start_time) + appointment.needed_time_min)
  end
end
