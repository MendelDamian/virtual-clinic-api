class Profession < ApplicationRecord
  has_many :user_professions
  has_many :users, through: :user_professions

  validates_uniqueness_of :name
end
