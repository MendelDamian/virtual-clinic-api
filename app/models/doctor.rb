class Doctor < User
  include Filterable

  has_many :user_professions, foreign_key: :user_id, dependent: :delete_all
  has_many :professions, through: :user_professions
  has_many :procedures, dependent: :destroy, inverse_of: :doctor, foreign_key: :user_id
  has_many :work_plans, dependent: :destroy, inverse_of: :doctor, foreign_key: :user_id
  # Scopes.
  default_scope { where(account_type: :doctor) }
  scope :filter_by_first_name, -> (first_name) { where("first_name LIKE ?", "%#{first_name}%") if first_name.present? }
  scope :filter_by_last_name, -> (last_name) { where("last_name LIKE ?", "%#{last_name}%") if last_name.present? }
end
