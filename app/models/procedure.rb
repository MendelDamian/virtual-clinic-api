class Procedure < ApplicationRecord
  include Filterable
  belongs_to :user, inverse_of: :procedures, foreign_key: :users_id

  scope :filter_by_name, -> (name) { where("name LIKE ?", "%#{name}%") if name.present? }

  validates_uniqueness_of :name, scope: :users_id
  validates :name, length: { minimum: 2 , maximum: 128}
  validates :needed_time_min, presence: true, numericality: {greater_than_or_equal_to: 20,less_than_or_equal_to: 7200, message: 'is incorrect' }

end

