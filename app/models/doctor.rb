class Doctor < User
  default_scope { where(account_type: :doctor) }

  has_many :user_professions
  has_many :professions, through: :user_professions
end
