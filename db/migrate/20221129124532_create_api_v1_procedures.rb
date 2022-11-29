class CreateApiV1Procedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.belongs_to :users, foreign_key: true
      t.string :name
      t.time :needed_time

      t.timestamps
    end
  end
end
