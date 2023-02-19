class AppointmentsManager::BoookAppointment < ::ApplicationService
  attr_reader :procedure, :start_time, :doctor

  def initialize(procedure, start_time)
    @procedure = procedure
    @start_time = start_time
    @doctor = procedure.doctor
  end

  def call
    available_slots = AppointmentsManager::AvailableAppointments.call(@procedure, @start_time.to_date)

    if available_slots.include? @start_time.strftime("%H:%M") and @start_time.to_datetime >= DateTime.now.to_datetime

  end

end
