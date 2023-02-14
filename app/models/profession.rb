class Profession < ApplicationRecord
  include Filterable

  has_many :user_professions, dependent: :delete_all
  has_many :doctors, through: :user_professions

  # Scopes.
  scope :filter_by_name, -> (name) { where("name ILIKE ?", "%#{name}%") }

  # Validations.
  validates :name, length: { maximum: 50, minimum: 2 }, uniqueness: true
end
