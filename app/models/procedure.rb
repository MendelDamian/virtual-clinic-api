class Procedure < ApplicationRecord
  include Filterable

  SHORTEST_PROCEDURE_TIME = 20
  LONGEST_PROCEDURE_TIME = 360

  belongs_to :doctor, inverse_of: :procedures, foreign_key: :user_id
  has_many :appointments, dependent: :destroy, inverse_of: :procedure, foreign_key: :procedure_id

  # Scopes.
  scope :filter_by_name, -> (name) { where("name LIKE ?", "%#{name}%") if name.present? }

  # Validations.
  validates_uniqueness_of :name, scope: :user_id
  validates :name, length: { minimum: 2, maximum: 128 }
  validates :needed_time_min, presence: true, numericality: {
    greater_than_or_equal_to: SHORTEST_PROCEDURE_TIME,
    less_than_or_equal_to: LONGEST_PROCEDURE_TIME,
    message: 'is incorrect'
  }
end

