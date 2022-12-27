class AddAppointment < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.belongs_to :doctor, null: false
      t.belongs_to :patient, null: false
      t.belongs_to :procedure, foreign_key: true, null: false
      t.integer :status, default: 0, null: false
      t.datetime :start_time, null: false

      t.timestamps null: false
    end

    add_foreign_key :appointments, :users, column: :doctor_id
    add_foreign_key :appointments, :users, column: :patient_id
  end
end
