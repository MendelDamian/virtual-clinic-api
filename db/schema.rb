# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_12_09_155910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "procedures", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.integer "needed_time_min", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_procedures_on_user_id"
  end

  create_table "professions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_professions_on_name", unique: true
  end

  create_table "user_professions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profession_id", null: false
    t.index ["profession_id"], name: "index_user_professions_on_profession_id"
    t.index ["user_id"], name: "index_user_professions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "account_type", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_plans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "day_of_week", default: 0, null: false
    t.integer "work_hour_start", default: 0, null: false
    t.integer "work_hour_end", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_work_plans_on_user_id"
  end

  add_foreign_key "procedures", "users"
  add_foreign_key "user_professions", "professions"
  add_foreign_key "user_professions", "users"
  add_foreign_key "work_plans", "users"
end
