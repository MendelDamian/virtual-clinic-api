class AppointmentsManager::BookAppointment < ::ApplicationService
  attr_reader :procedure, :start_time, :curr_user

  FAILURE = :failure

  def initialize(procedure, start_time, curr_user)
    @procedure = procedure
    @start_time = start_time
    @doctor = procedure.doctor
    @curr_user = curr_user
    @available_slots = AppointmentsManager::AvailableAppointments.call(@procedure, @start_time.to_date)
  end

  def call
    unless @available_slots.include? @start_time.strftime("%H:%M") and @start_time.to_datetime >= DateTime.now.to_datetime
      return FAILURE
    end

      @appointment = @curr_user.appointments.new(doctor_id: @doctor.id, procedure_id: @procedure.id, start_time: @start_time)
      if @appointment.save
        return @appointment
      else
        FAILURE
      end
    end
end
