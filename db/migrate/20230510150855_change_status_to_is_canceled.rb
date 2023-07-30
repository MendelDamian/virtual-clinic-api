class ChangeStatusToIsCanceled < ActiveRecord::Migration[6.1]
  def change
    add_column(:appointments, :is_canceled, :boolean, default: false, null: false)
    Appointment.where("status=0").update_all("is_canceled=FALSE")
    Appointment.where("status=1").update_all("is_canceled=TRUE")
    remove_column(:appointments, :status)
  end
end
