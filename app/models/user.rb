class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum account_type: {
    user: 0,
    patient: 1,
    doctor: 2
  }, _prefix: true
end
