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

ActiveRecord::Schema.define(:version => 20111212105937) do

  create_table "admins", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["invitation_token"], :name => "index_admins_on_invitation_token"
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "batches", :force => true do |t|
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
    t.integer  "mobile_number"
    t.string   "exp"
    t.string   "salary_exp"
    t.boolean  "starred"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.string   "perishable_token"
  end

  create_table "events", :force => true do |t|
    t.datetime "event_date"
    t.string   "name"
    t.string   "experience"
    t.string   "location"
    t.string   "description"
    t.string   "category"
    t.string   "tech_spec"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_candidates", :force => true do |t|
    t.integer  "event_id"
    t.integer  "candidate_id"
    t.integer  "roll_num"
    t.boolean  "confirmed",    :default => false
    t.boolean  "attended",     :default => false
    t.boolean  "waitlist",     :default => false
    t.boolean  "cancellation", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "batch_id"
  end

end
