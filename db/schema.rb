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

ActiveRecord::Schema.define(:version => 20111018145539) do

  create_table "builds", :force => true do |t|
    t.integer  "project_id"
    t.string   "commit_hash"
    t.string   "commit_message"
    t.string   "commit_author"
    t.datetime "commit_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commands", :force => true do |t|
    t.integer  "project_id"
    t.string   "command"
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer  "build_id"
    t.integer  "command_id"
    t.string   "log"
    t.string   "status_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
