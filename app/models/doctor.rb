class Doctor < User
  default_scope { where(account_type: :doctor) }

  # ERROR: update or delete on table "professions" violates foreign key constraint "fk_rails_7715598ad9" on table "user_professions" (PG::ForeignKeyViolation)
  has_many :user_professions, foreign_key: :user_id, dependent: :delete_all
  has_many :professions, through: :user_professions
end
