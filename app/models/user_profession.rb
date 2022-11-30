class UserProfession < ApplicationRecord
  belongs_to :user
  belongs_to :profession

  validates_uniqueness_of :user_id, scope: :profession_id
end
