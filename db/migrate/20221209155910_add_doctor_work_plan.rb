class AddDoctorWorkPlan < ActiveRecord::Migration[6.1]
  def change
    create_table :work_plans do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :day_of_week, default: 0
      t.integer :work_hour_start, default: 0
      t.integer :work_hour_end, default: 0

      t.timestamps null: false
    end
  end
end
