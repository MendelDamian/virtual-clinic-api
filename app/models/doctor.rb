class Doctor < User
  default_scope { where(account_type: :doctor) }

  has_many :user_professions, foreign_key: :user_id
  has_many :professions, through: :user_professions
end
