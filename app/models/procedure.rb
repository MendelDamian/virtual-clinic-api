class Procedure < ApplicationRecord
  belongs_to :user, inverse_of: :procedures, foreign_key: :users_id
  validates_uniqueness_of :name, scope: :users_id
  validates :name, length: { minimum: 2 , maximum: 128}
  validates :needed_time, presence: true
end
