class UserProfession < ApplicationRecord
  belongs_to :doctor
  belongs_to :profession
end
