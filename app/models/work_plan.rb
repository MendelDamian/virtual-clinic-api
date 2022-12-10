class WorkPlan < ApplicationRecord
  include Filterable
  belongs_to :doctor, inverse_of: :work_plans, foreign_key: :user_id

  # Scopes.
  scope :filter_by_day_of_week, -> (day) { where("day_of_week LIKE ?", "%#{day}%") if day.present?}

end