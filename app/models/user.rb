class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum account_type: {
    patient: 0,
    doctor: 1
  }, _prefix: true

  has_many :user_professions
  has_many :professions, through: :user_professions

  validates_inclusion_of :account_type, in: account_types.keys, message: 'is not a valid account_type'

  def account_type=(value)
    self[:account_type] = value
  rescue ArgumentError
    self[:account_type] = nil
  end
end
