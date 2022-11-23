class Patient < User
  default_scope { where(account_type: :patient) }
end
