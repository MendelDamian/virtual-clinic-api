class WorkPlan < ApplicationRecord
  include Filterable
  belongs_to :doctor, inverse_of: :work_plans, foreign_key: :user_id

  enum day_of_week:{
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }, _prefix: true

  # Scopes.
  scope :filter_by_day_of_week, -> (day) { where("day_of_week LIKE ?", "%#{day}%") if day.present? }

  validates_uniqueness_of :day_of_week, scope: :user_id
  validates_inclusion_of :day_of_week, in: day_of_weeks.keys, message: 'is not a valid day of week'
  validates :work_hour_start, :work_hour_end, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 24 }
  validates :work_hour_start, numericality: { less_than: :work_hour_end }

  def day_of_week=(value)
    self[:day_of_week] = value
  rescue ArgumentError
    self[:day_of_week] = nil
  end

end
