class UserProfession < ApplicationRecord
  belongs_to :doctor, foreign_key: :user_id
  belongs_to :profession

  validates_uniqueness_of :user_id, scope: :profession_id
end
