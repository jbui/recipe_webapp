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

ActiveRecord::Schema.define(:version => 20120318084721) do

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "image_url"
    t.text     "ingredients"
    t.text     "directions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "captured_key"
  end

  create_table "recipes_users", :force => true do |t|
    t.integer "recipe_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
