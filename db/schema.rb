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

ActiveRecord::Schema.define(version: 20150329040307) do

  create_table "config_tables", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manifests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "region_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "past_level"
  end

  create_table "problems", force: :cascade do |t|
    t.integer  "difficulty"
    t.text     "statement"
    t.text     "sample_input"
    t.text     "sample_output"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "active"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.integer  "x"
    t.integer  "y"
    t.integer  "rounds"
  end

  create_table "runs", force: :cascade do |t|
    t.integer  "problem_id"
    t.text     "code"
    t.text     "input"
    t.text     "expected_output"
    t.text     "output"
    t.boolean  "success"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "tested"
  end

  create_table "test_cases", force: :cascade do |t|
    t.integer  "problem_id"
    t.text     "input"
    t.text     "output"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "gender"
    t.string   "name"
    t.string   "college"
    t.integer  "score"
    t.string   "phone"
    t.string   "password_reset_code"
  end

end
