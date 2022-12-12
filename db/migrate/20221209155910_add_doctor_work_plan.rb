class AddDoctorWorkPlan < ActiveRecord::Migration[6.1]
  def change
    create_table :work_plans do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.integer :day_of_week, default: 0, null: false
      t.integer :work_hour_start, default: 0, null: false
      t.integer :work_hour_end, default: 0, null: false

      t.timestamps null: false
    end
  end
end
