class Appointment < ApplicationRecord
  belongs_to :doctor, inverse_of: :appointments, foreign_key: :doctor_id
  belongs_to :patient, inverse_of: :appointments, foreign_key: :patient_id

  enum status: {
    pending: 0,
    confirmed: 1,
    canceled: 2
  }, _prefix: true

  # TODO add validation

  def status=(value)
    self[:status] = value
  rescue ArgumentError
    self[:status] = nil
  end
end
