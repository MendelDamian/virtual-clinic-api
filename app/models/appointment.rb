class Appointment < ApplicationRecord
  include Filterable

  belongs_to :doctor, inverse_of: :appointments, foreign_key: :doctor_id
  belongs_to :patient, inverse_of: :appointments, foreign_key: :patient_id
  belongs_to :procedure, inverse_of: :appointments, foreign_key: :procedure_id

  # Scopes.
  scope :filter_by_start_time, -> (start_time) { where(start_time: start_time.all_day) }
  scope :not_canceled, -> { where(is_canceled: false) }

  # Validations.
  validates :start_time, presence: true
  validates :is_canceled, inclusion: [true, false]

  # Delegates.
  delegate :needed_time_min, to: :procedure
end
