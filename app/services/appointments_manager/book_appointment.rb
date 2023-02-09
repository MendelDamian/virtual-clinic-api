class AppointmentsManager::BookAppointment < ::ApplicationService
  attr_reader :procedure, :start_time, :doctor

  def initialize(procedure, start_time)
    @procedure = procedure
    @start_time = start_time
    @doctor = procedure.doctor
  end

  def call
    
  end
end
