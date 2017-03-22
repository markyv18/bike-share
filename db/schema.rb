# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170320224928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bikes", force: :cascade do |t|
    t.integer  "bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
  end

  create_table "stations", force: :cascade do |t|
    t.text     "name"
    t.integer  "dock_count"
    t.date     "installation_date"
    t.float    "lat"
    t.float    "long"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "city_id"
  end

  create_table "trips", force: :cascade do |t|
    t.integer  "duration"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "subscription_type"
    t.integer  "zip_code"
    t.integer  "weather_id"
    t.integer  "bike_id"
    t.integer  "start_station_id"
    t.integer  "end_station_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "weather_conditions", force: :cascade do |t|
    t.float    "max_temperature_f"
    t.float    "min_temperature_f"
    t.float    "mean_temperature_f"
    t.float    "mean_humidity"
    t.float    "mean_visibility_miles"
    t.float    "mean_wind_speed_mph"
    t.float    "precipitation_inches"
    t.date     "date"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
