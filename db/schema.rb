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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111129140401) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", :force => true do |t|
    t.integer  "number"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "capacity"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", :force => true do |t|
    t.string   "name"
    t.date     "dob"
    t.text     "address"
    t.string   "current_state"
    t.string   "home_town"
    t.string   "email"
    t.integer  "mobile_num"
    t.string   "exp"
    t.string   "salary_exp"
    t.integer  "batch_id"
    t.boolean  "starred"
    t.binary   "resume",        :limit => 1048576
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.date     "event_date"
    t.string   "name"
    t.string   "experience"
    t.string   "location"
    t.string   "description"
    t.string   "catagory"
    t.string   "tech_spec"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_candidates", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "candidate_id"
    t.boolean "attended"
    t.boolean "waitlist"
    t.boolean "cancellation"
  end

end
