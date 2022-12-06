class Doctor < User
  default_scope { where(account_type: :doctor) }

  has_many :user_professions, foreign_key: :user_id, dependent: :delete_all
  has_many :professions, through: :user_professions
end
