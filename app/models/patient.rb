class Patient < User
  has_many :appointments, dependent: :destroy, inverse_of: :patient, foreign_key: :patient_id

  # Scopes.
  default_scope { where(account_type: :patient) }
end
