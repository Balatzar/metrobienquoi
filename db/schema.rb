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

ActiveRecord::Schema[8.0].define(version: 2024_11_29_154617) do
  create_table "stations", force: :cascade do |t|
    t.integer "rang"
    t.string "reseau"
    t.string "name"
    t.integer "trafic"
    t.string "correspondance_1"
    t.string "correspondance_2"
    t.string "correspondance_3"
    t.string "correspondance_4"
    t.string "correspondance_5"
    t.string "ville"
    t.string "arrondissement_pour_paris"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
