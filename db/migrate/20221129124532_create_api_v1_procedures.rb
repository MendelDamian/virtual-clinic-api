class CreateApiV1Procedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.belongs_to :user, foreign_key: true
      t.string :name
      t.integer :needed_time_min

      t.timestamps
    end
  end
end
