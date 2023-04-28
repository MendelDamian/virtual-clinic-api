class AddChat < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.string :channel_name, null: false
      t.belongs_to :doctor, null: false
      t.belongs_to :patient, null: false

      t.timestamps null: false
    end

    add_foreign_key :chats, :users, column: :doctor_id
    add_foreign_key :chats, :users, column: :patient_id
  end
end
