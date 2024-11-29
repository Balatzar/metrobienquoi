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

ActiveRecord::Schema[8.0].define(version: 2024_11_30_001000) do
  create_table "itineraries", force: :cascade do |t|
    t.integer "start_station_id", null: false
    t.integer "end_station_id", null: false
    t.integer "distance"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_station_id"], name: "index_itineraries_on_end_station_id"
    t.index ["start_station_id"], name: "index_itineraries_on_start_station_id"
  end

  create_table "searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches_stations", force: :cascade do |t|
    t.integer "search_id", null: false
    t.integer "station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["search_id", "station_id"], name: "index_searches_stations_on_search_id_and_station_id", unique: true
    t.index ["search_id"], name: "index_searches_stations_on_search_id"
    t.index ["station_id"], name: "index_searches_stations_on_station_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_id"
    t.string "version"
    t.string "station_type"
    t.decimal "x_coord", precision: 10, scale: 2
    t.decimal "y_coord", precision: 10, scale: 2
    t.string "city"
    t.string "postal_code"
    t.boolean "accessibility"
    t.string "audible_signals"
    t.string "visual_signs"
    t.integer "fare_zone"
    t.string "zda_id"
    t.decimal "latitude", precision: 10, scale: 8
    t.decimal "longitude", precision: 10, scale: 8
    t.index ["external_id"], name: "index_stations_on_external_id", unique: true
  end

  add_foreign_key "itineraries", "stations", column: "end_station_id"
  add_foreign_key "itineraries", "stations", column: "start_station_id"
  add_foreign_key "searches_stations", "searches"
  add_foreign_key "searches_stations", "stations"
end
