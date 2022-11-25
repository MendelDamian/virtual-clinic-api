class Doctor < User
  default_scope { where(account_type: :doctor) }
end
