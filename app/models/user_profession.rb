class UserProfession < ApplicationRecord
  belongs_to :user
  belongs_to :profession
end
