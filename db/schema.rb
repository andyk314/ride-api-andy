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

ActiveRecord::Schema[7.0].define(version: 2023_02_01_224716) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.text "home_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "home_address_lat"
    t.float "home_address_long"
  end

  create_table "rides", force: :cascade do |t|
    t.bigint "driver_id", null: false
    t.text "start_address"
    t.text "destination_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "destination_address_lat"
    t.float "destination_address_long"
    t.float "start_address_lat"
    t.float "start_address_long"
    t.float "ride_distance"
    t.float "ride_duration"
    t.float "commute_duration"
    t.float "ride_earnings"
    t.float "ride_score", default: 0.0
    t.index ["driver_id"], name: "index_rides_on_driver_id"
  end

  add_foreign_key "rides", "drivers"
end
