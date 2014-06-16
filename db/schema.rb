# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140616150143) do

  create_table "affinities", force: true do |t|
    t.float    "aff"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "google_id"
    t.time     "start_time"
    t.string   "summary"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
  end

  create_table "places", force: true do |t|
    t.string   "loc"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "rec_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating"
    t.string   "address"
    t.string   "full_address"
    t.string   "img"
    t.string   "url"
  end

  create_table "places_tags", id: false, force: true do |t|
    t.integer "place_id", null: false
    t.integer "tag_id",   null: false
  end

  create_table "recs", force: true do |t|
    t.string   "loc"
    t.integer  "place_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recs_tags", id: false, force: true do |t|
    t.integer "rec_id", null: false
    t.integer "tag_id", null: false
  end

  create_table "tags", force: true do |t|
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "curloc"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
