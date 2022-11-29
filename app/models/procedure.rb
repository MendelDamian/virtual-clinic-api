class Procedure < ApplicationRecord
  belongs_to :user
  validates :name, length: { minimum: 2 , maximum: 128}
  validates :needed_time, presence: true
end
