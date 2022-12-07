class AddProfession < ActiveRecord::Migration[6.1]
  def change
    create_table :professions do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :user_professions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :profession, null: false, foreign_key: true
    end

    add_index :professions, :name, unique: true
  end
end
