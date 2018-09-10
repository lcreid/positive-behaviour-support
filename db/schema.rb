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

ActiveRecord::Schema.define(version: 2018_09_10_203227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "completed_expectations", force: :cascade do |t|
    t.string "description"
    t.string "observation"
    t.string "comment"
    t.integer "completed_routine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "expectation_id"
    t.index ["completed_routine_id"], name: "index_completed_expectations_on_completed_routine_id"
    t.index ["expectation_id"], name: "index_completed_expectations_on_expectation_id"
  end

  create_table "completed_routines", force: :cascade do |t|
    t.string "name"
    t.string "comment"
    t.integer "person_id"
    t.integer "routine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "awarded", default: false
    t.datetime "routine_done_at"
    t.integer "recorded_by_id"
    t.integer "updated_by_id"
    t.integer "routine_category_id"
    t.index ["person_id"], name: "index_completed_routines_on_person_id"
    t.index ["recorded_by_id"], name: "index_completed_routines_on_recorded_by_id"
    t.index ["routine_category_id"], name: "index_completed_routines_on_routine_category_id"
    t.index ["routine_id"], name: "index_completed_routines_on_routine_id"
    t.index ["updated_by_id"], name: "index_completed_routines_on_updated_by_id"
  end

  create_table "docks", force: :cascade do |t|
    t.string "name"
    t.date "observation_date"
    t.integer "score_on_success"
    t.integer "daily_quota"
    t.integer "remaining"
    t.integer "person_id"
    t.integer "health_point_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["health_point_id"], name: "index_docks_on_health_point_id"
    t.index ["person_id"], name: "index_docks_on_person_id"
  end

  create_table "expectations", force: :cascade do |t|
    t.string "description"
    t.integer "routine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["routine_id"], name: "index_expectations_on_routine_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "target"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_goals_on_person_id"
  end

  create_table "health_points", force: :cascade do |t|
    t.string "name"
    t.integer "score_on_success"
    t.integer "daily_quota"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_health_points_on_person_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "invitor_id"
    t.string "e_mail"
    t.string "token"
    t.string "disposition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["invitor_id"], name: "index_invitations_on_invitor_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "person_a_id"
    t.integer "person_b_id"
    t.string "b_is"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_a_id"], name: "index_links_on_person_a_id"
    t.index ["person_b_id"], name: "index_links_on_person_b_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "to_id"
    t.integer "from_id"
    t.boolean "read", default: false
    t.string "message_type"
    t.boolean "reported_as_spam", default: false
    t.string "recipient_action"
    t.string "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["from_id"], name: "index_messages_on_from_id"
    t.index ["to_id"], name: "index_messages_on_to_id"
  end

  create_table "people", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "creator_id"
    t.string "short_name"
    t.index ["creator_id"], name: "index_people_on_creator_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "person_users", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "user_id"
    t.index ["person_id"], name: "index_person_users_on_person_id"
    t.index ["user_id"], name: "index_person_users_on_user_id"
  end

  create_table "routine_categories", force: :cascade do |t|
    t.integer "person_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_routine_categories_on_person_id"
  end

  create_table "routines", force: :cascade do |t|
    t.string "name"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "goal_id"
    t.index ["goal_id"], name: "index_routines_on_goal_id"
    t.index ["person_id"], name: "index_routines_on_person_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "time_zone"
    t.string "email"
  end

  add_foreign_key "person_users", "people"
  add_foreign_key "person_users", "users"
end
