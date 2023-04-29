class AddMessage < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.belongs_to :chat, foreign_key: true, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
