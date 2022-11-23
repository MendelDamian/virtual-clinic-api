class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum account_type: {
    patient: 0,
    doctor: 1
  }, _prefix: true
end
