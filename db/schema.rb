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

ActiveRecord::Schema.define(version: 2021_06_19_095517) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "farmer_id"
    t.text "chat", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.index ["customer_id"], name: "index_chats_on_customer_id"
    t.index ["event_id"], name: "index_chats_on_event_id"
    t.index ["farmer_id"], name: "index_chats_on_farmer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nickname", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_image_id"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "farmer_id", null: false
    t.float "evaluation", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.string "evaluation_image_id"
    t.index ["customer_id"], name: "index_evaluations_on_customer_id"
    t.index ["farmer_id"], name: "index_evaluations_on_farmer_id"
  end

  create_table "event_favorites", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_event_favorites_on_customer_id"
    t.index ["event_id"], name: "index_event_favorites_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "farmer_id", null: false
    t.string "title", null: false
    t.string "plan_image_id", null: false
    t.text "body", null: false
    t.integer "fee", null: false
    t.text "cancel_change", null: false
    t.string "location", null: false
    t.text "access", null: false
    t.integer "parking", default: 0, null: false
    t.text "etc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["farmer_id"], name: "index_events_on_farmer_id"
    t.index ["location"], name: "index_events_on_location"
  end

  create_table "farmers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "farm_address", null: false
    t.string "store_address", null: false
    t.string "farmer_image_id"
    t.text "introduction"
    t.string "image_1_id"
    t.string "image_2_id"
    t.string "image_3_id"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "store_latitude"
    t.float "store_longitude"
    t.index ["email"], name: "index_farmers_on_email", unique: true
    t.index ["name"], name: "index_farmers_on_name"
    t.index ["reset_password_token"], name: "index_farmers_on_reset_password_token", unique: true
    t.index ["store_address"], name: "index_farmers_on_store_address", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "farmer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_follows_on_customer_id"
    t.index ["farmer_id"], name: "index_follows_on_farmer_id"
  end

  create_table "news", force: :cascade do |t|
    t.integer "farmer_id", null: false
    t.text "news", null: false
    t.string "news_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farmer_id"], name: "index_news_on_farmer_id"
  end

  create_table "notices", force: :cascade do |t|
    t.integer "farmer_id"
    t.integer "customer_id"
    t.integer "event_id"
    t.integer "action", null: false
    t.boolean "checked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reservation_id"
    t.index ["customer_id"], name: "index_notices_on_customer_id"
    t.index ["event_id"], name: "index_notices_on_event_id"
    t.index ["farmer_id"], name: "index_notices_on_farmer_id"
    t.index ["reservation_id"], name: "index_notices_on_reservation_id"
  end

  create_table "recipe_favorites", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_recipe_favorites_on_customer_id"
    t.index ["recipe_id"], name: "index_recipe_favorites_on_recipe_id"
  end

  create_table "recipe_tags", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id", "tag_id"], name: "index_recipe_tags_on_recipe_id_and_tag_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_tags_on_recipe_id"
    t.index ["tag_id"], name: "index_recipe_tags_on_tag_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "farmer_id", null: false
    t.string "title", null: false
    t.string "recipe_image_id", null: false
    t.integer "duration", null: false
    t.integer "amount", null: false
    t.text "ingredient", null: false
    t.text "recipe", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farmer_id"], name: "index_recipes_on_farmer_id"
    t.index ["title"], name: "index_recipes_on_title"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "schedule_id", null: false
    t.integer "people", null: false
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
    t.index ["schedule_id"], name: "index_reservations_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "event_id", null: false
    t.date "date", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_deleted", default: false
    t.integer "people", null: false
    t.boolean "is_full", default: false
    t.index ["event_id"], name: "index_schedules_on_event_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag"], name: "index_tags_on_tag", unique: true
  end

end
