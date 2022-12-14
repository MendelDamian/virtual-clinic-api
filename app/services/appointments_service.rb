class AppointmentsService
  def self.available_slots(procedure, date)
    doctor = procedure.doctor
    work_plan = doctor.work_plans.find_by(day_of_week: date.wday)
    appointments = doctor.appointments.filter_by_start_time(date)

    time_curr = minutes(work_plan.work_hour_start)
    time_end = minutes(work_plan.work_hour_end)

    available_slots = []
    while time_curr + procedure.needed_time_min <= time_end
      skip = false
      appointments.each do |appointment|
        if between?(time_curr + procedure.needed_time_min, appointment)
          skip = true
          time_curr = datetime_to_minutes(appointment.start_time) + appointment.procedure.needed_time_min
          break
        end
      end

      next if skip

      available_slots << format_time(time_curr)
      time_curr += Procedure::SHORTEST_PROCEDURE_TIME
    end

    available_slots
  end

  private

  def self.format_time(time)
    Time.parse("#{time / 60}:#{time % 60}").strftime("%H:%M")
  end

  def self.between?(time_curr, appointment)
    time_curr > datetime_to_minutes(appointment.start_time) &&
      time_curr < datetime_to_minutes(appointment.start_time) + appointment.procedure.needed_time_min
  end

  def self.datetime_to_minutes(datetime)
    datetime.hour * 60 + datetime.min
  end

  def self.minutes(hours)
    hours * 60
  end
end
