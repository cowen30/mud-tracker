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

ActiveRecord::Schema.define(version: 2021_07_11_203213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.integer "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo_path"
  end

  create_table "event_details", force: :cascade do |t|
    t.integer "event_id"
    t.integer "event_type_id"
    t.decimal "lap_distance"
    t.decimal "lap_elevation"
    t.string "badge_id"
    t.integer "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.integer "display_order"
    t.integer "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.date "date"
    t.string "latitude"
    t.string "longitude"
    t.boolean "archived", default: false, null: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "participants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_detail_id"
    t.string "participation_day"
    t.integer "contender_status_id"
    t.integer "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "active", default: false, null: false
    t.string "verification_code"
    t.integer "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reset_code"
  end

  add_foreign_key "brands", "users", column: "updated_by"
  add_foreign_key "event_details", "event_types"
  add_foreign_key "event_details", "events"
  add_foreign_key "event_details", "users", column: "updated_by"
  add_foreign_key "event_types", "brands"
  add_foreign_key "event_types", "users", column: "updated_by"
  add_foreign_key "events", "brands"
  add_foreign_key "events", "users", column: "created_by"
  add_foreign_key "events", "users", column: "updated_by"
  add_foreign_key "participants", "event_details"
  add_foreign_key "participants", "users"
  add_foreign_key "participants", "users", column: "updated_by"
  add_foreign_key "users", "users", column: "updated_by"
end
