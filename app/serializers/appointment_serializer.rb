class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :status

  CANCELED = :canceled
  PAST = :past
  PRESENT = :present
  PENDING = :pending

  def initialize(*args)
    super
    @curr_date = Time.now.to_date
    @curr_time = Time.now.to_time
  end

  def status
    return CANCELED if object.is_canceled?

    appointment_date = object.start_time.to_date
    start_time = object.start_time.to_time

    case
    when appointment_date < @curr_date
      PAST
    when appointment_date > @curr_date || start_time > @curr_time
      PENDING
    else
      PRESENT
    end
  end

  belongs_to :doctor, serializer: DoctorSerializer
  belongs_to :patient, serializer: PatientSerializer
  belongs_to :procedure, serializer: ProcedureSerializer
end
