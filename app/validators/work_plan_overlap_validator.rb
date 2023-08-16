class WorkPlanOverlapValidator < ActiveModel::Validator
  def validate(record)
    return unless record.doctor

    work_plans = record.doctor.work_plans

    work_plans.each do |work_plan|
      next if record.id == work_plan.id

      if record.day_of_week == work_plan.day_of_week
        if record.work_hour_start < work_plan.work_hour_end && record.work_hour_end > work_plan.work_hour_start
          record.errors.add(:base, 'Work plan overlaps with another work plan')
          break
        end
      end
    end
  end
end
