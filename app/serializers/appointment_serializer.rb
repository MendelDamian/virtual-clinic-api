class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :status

  CANCELED = :CANCELED
  PAST = :PAST
  PRESENT = :PRESENT
  PENDING = :PENDING

  def status
    if object.is_canceled
      return CANCELED
    end

    curr_date = Time.now.to_date
    appointment_date = object.start_time.to_date

    if curr_date > appointment_date
      PAST
    elsif curr_date < appointment_date
      return PENDING
    else
      curr_time = Time.now.to_time
      start_time = object.start_time.to_time

      if start_time > curr_time
        return PENDING
      elsif start_time < curr_time
        return PAST
      end

      PRESENT
    end
  end

  belongs_to :doctor, serializer: DoctorSerializer
  belongs_to :patient, serializer: PatientSerializer
  belongs_to :procedure, serializer: ProcedureSerializer
end
