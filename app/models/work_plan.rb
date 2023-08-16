class WorkPlan < ApplicationRecord
  belongs_to :doctor, inverse_of: :work_plans, foreign_key: :user_id

  before_save :merge_consecutive_work_plans

  enum day_of_week: {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }, _prefix: true

  validates_inclusion_of :day_of_week, in: day_of_weeks.keys, message: 'is not a valid day of week'
  validates :work_hour_start, :work_hour_end, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 24 }
  validates :work_hour_start, numericality: { less_than: :work_hour_end, message: 'must be before work hour end' }

  include ActiveModel::Validations
  validates_with WorkPlanOverlapValidator

  scope :filter_by_wday, -> (wday) { where(day_of_week: wday) }

  def day_of_week=(value)
    self[:day_of_week] = value
  rescue ArgumentError
    self[:day_of_week] = nil
  end

  private

  def merge_consecutive_work_plans
    previous_work_plan = doctor.work_plans.filter_by_wday(day_of_week).find_by(work_hour_end: work_hour_start)
    next_work_plan = doctor.work_plans.filter_by_wday(day_of_week).find_by(work_hour_start: work_hour_end)

    if previous_work_plan && next_work_plan
      self.update(work_hour_start: previous_work_plan.work_hour_start, work_hour_end: next_work_plan.work_hour_end)
      previous_work_plan.destroy
      next_work_plan.destroy
    elsif previous_work_plan
      self.update(work_hour_start: previous_work_plan.work_hour_start)
      previous_work_plan.destroy
    elsif next_work_plan
      self.update(work_hour_end: next_work_plan.work_hour_end)
      next_work_plan.destroy
    end
  end
end
