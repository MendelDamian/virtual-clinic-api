class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one_attached :profile_picture

  enum account_type: {
    patient: 0,
    doctor: 1
  }, _prefix: true

  # Validations
  validates :first_name, :last_name, length: { maximum: 50, minimum: 2 }
  validates_inclusion_of :account_type, in: account_types.keys, message: 'is not a valid account type'

  def account_type=(value)
    self[:account_type] = value
  rescue ArgumentError
    self[:account_type] = nil
  end
end
