class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :status

  belongs_to :doctor, serializer: DoctorSerializer
  belongs_to :patient, serializer: PatientSerializer
  belongs_to :procedure, serializer: ProcedureSerializer
end
