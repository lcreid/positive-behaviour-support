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

ActiveRecord::Schema.define(version: 20140303215338) do

  create_table "completed_expectations", force: true do |t|
    t.string   "description"
    t.string   "observation"
    t.string   "comment"
    t.integer  "completed_routine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expectation_id"
  end

  add_index "completed_expectations", ["completed_routine_id"], name: "index_completed_expectations_on_completed_routine_id"
  add_index "completed_expectations", ["expectation_id"], name: "index_completed_expectations_on_expectation_id"

  create_table "completed_routines", force: true do |t|
    t.string   "name"
    t.string   "comment"
    t.integer  "person_id"
    t.integer  "routine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "awarded",             default: false
    t.datetime "routine_done_at"
    t.integer  "recorded_by_id"
    t.integer  "updated_by_id"
    t.integer  "routine_category_id"
  end

  add_index "completed_routines", ["person_id"], name: "index_completed_routines_on_person_id"
  add_index "completed_routines", ["recorded_by_id"], name: "index_completed_routines_on_recorded_by_id"
  add_index "completed_routines", ["routine_category_id"], name: "index_completed_routines_on_routine_category_id"
  add_index "completed_routines", ["routine_id"], name: "index_completed_routines_on_routine_id"
  add_index "completed_routines", ["updated_by_id"], name: "index_completed_routines_on_updated_by_id"

  create_table "expectations", force: true do |t|
    t.string   "description"
    t.integer  "routine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expectations", ["routine_id"], name: "index_expectations_on_routine_id"

  create_table "goals", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "target"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goals", ["person_id"], name: "index_goals_on_person_id"

  create_table "invitations", force: true do |t|
    t.integer  "invitor_id"
    t.string   "e_mail"
    t.string   "token"
    t.string   "disposition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["invitor_id"], name: "index_invitations_on_invitor_id"

  create_table "links", force: true do |t|
    t.integer  "person_a_id"
    t.integer  "person_b_id"
    t.string   "b_is"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["person_a_id"], name: "index_links_on_person_a_id"
  add_index "links", ["person_b_id"], name: "index_links_on_person_b_id"

  create_table "messages", force: true do |t|
    t.integer  "to_id"
    t.integer  "from_id"
    t.boolean  "read",             default: false
    t.string   "message_type"
    t.boolean  "reported_as_spam", default: false
    t.string   "recipient_action"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["from_id"], name: "index_messages_on_from_id"
  add_index "messages", ["to_id"], name: "index_messages_on_to_id"

  create_table "people", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.string   "short_name"
  end

  add_index "people", ["creator_id"], name: "index_people_on_creator_id"
  add_index "people", ["user_id"], name: "index_people_on_user_id"

  create_table "routine_categories", force: true do |t|
    t.integer  "person_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routine_categories", ["person_id"], name: "index_routine_categories_on_person_id"

  create_table "routines", force: true do |t|
    t.string   "name"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal_id"
  end

  add_index "routines", ["goal_id"], name: "index_routines_on_goal_id"
  add_index "routines", ["person_id"], name: "index_routines_on_person_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
  end

end
