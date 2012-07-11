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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120707154628) do

  create_table "builds", :force => true do |t|
    t.integer  "project_id"
    t.string   "commit_hash"
    t.string   "commit_message"
    t.string   "commit_author"
    t.datetime "commit_date"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "commit_author_email"
  end

  create_table "commands", :force => true do |t|
    t.integer  "project_id"
    t.string   "command"
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer "issuer_id"
    t.integer "project_id"
    t.string  "email"
    t.string  "role"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.boolean  "recentizer"
    t.string   "branch"
    t.string   "folder_path"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "hook_token"
    t.boolean  "build_nightly", :default => false
  end

  create_table "results", :force => true do |t|
    t.integer  "build_id"
    t.integer  "command_id"
    t.string   "log_path"
    t.string   "status_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rights", :force => true do |t|
    t.integer "project_id", :null => false
    t.integer "user_id",    :null => false
    t.string  "role",       :null => false
  end

  create_table "users", :force => true do |t|
    t.boolean  "admin",                  :default => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
