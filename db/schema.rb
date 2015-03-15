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

ActiveRecord::Schema.define(version: 20150314063233) do

  create_table "admin_problems", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_regions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_runs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_tables", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", force: true do |t|
    t.integer  "difficulty"
    t.text     "statement"
    t.text     "sample_input"
    t.text     "sample_output"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "regions", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runs", force: true do |t|
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

  create_table "test_cases", force: true do |t|
    t.integer  "problem_id"
    t.text     "input"
    t.text     "output"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
