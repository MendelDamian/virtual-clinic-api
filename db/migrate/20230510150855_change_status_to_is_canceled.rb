class ChangeStatusToIsCanceled < ActiveRecord::Migration[6.1]
  def change
    add_column(:appointments, :is_canceled, :boolean, default: false, null: false)
    Appointment.status_canceled.update_all("is_canceled=TRUE")
    Appointment.status_pending.update_all("is_canceled=FALSE")
    remove_column(:appointments, :status)
  end
end
