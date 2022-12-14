class Appointment < ApplicationRecord
  belongs_to :doctor, inverse_of: :appointments, foreign_key: :doctor_id
  belongs_to :patient, inverse_of: :appointments, foreign_key: :patient_id
  belongs_to :procedure, inverse_of: :appointments, foreign_key: :procedure_id

  enum status: {
    pending: 0,
    confirmed: 1,
    canceled: 2
  }, _prefix: 'status'

  validates_inclusion_of :status, in: statuses.keys, message: 'is not a valid status'
  validates :start_time, presence: true

  def status=(value)
    self[:status] = value
  rescue ArgumentError
    self[:status] = nil
  end
end