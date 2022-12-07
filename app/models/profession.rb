class Profession < ApplicationRecord
  has_many :user_professions, dependent: :destroy
  has_many :users, through: :user_professions

  # Filters
  scope :filter_by_name, -> (name) { where('name LIKE ?', "%#{name}%") }

  # Validations
  validates :name, length: { maximum: 50, minimum: 2 }, uniqueness: true
end
