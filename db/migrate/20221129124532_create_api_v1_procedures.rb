class CreateApiV1Procedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.belongs_to :user, foreign_key: true
      t.string :name, null: false
      t.integer :needed_time_min, null: false

      t.timestamps null: false
    end
  end
end
