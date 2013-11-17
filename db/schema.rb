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

ActiveRecord::Schema.define(:version => 20131116143914) do

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "total_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordered_at"
  end

  create_table "menuitems", :force => true do |t|
    t.integer  "release_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "names", :force => true do |t|
    t.string   "sei",        :default => ""
    t.string   "mei",        :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string   "name",        :default => ""
    t.string   "phone",       :default => ""
    t.string   "address",     :default => ""
    t.datetime "due",         :default => '2011-12-24 00:00:00'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "due_year",    :default => 2011
    t.integer  "due_month",   :default => 12
    t.integer  "due_day"
    t.integer  "due_hour"
    t.integer  "due_minute",  :default => 0
    t.integer  "total_price"
    t.string   "payment",     :default => ""
    t.string   "means",       :default => ""
    t.integer  "amount_paid", :default => 0
    t.integer  "balance",     :default => 0
    t.string   "state",       :default => ""
    t.text     "note",        :default => ""
    t.integer  "ordered_at"
  end

  create_table "preferences", :force => true do |t|
    t.string   "name",                       :null => false
    t.text     "value",      :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "old_title",  :default => ""
    t.string   "size",       :default => ""
    t.integer  "price"
    t.integer  "remain",     :default => -1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "title_id"
    t.boolean  "on_sale",    :default => true
    t.integer  "limitation", :default => -1
    t.string   "release",    :default => ""
  end

  create_table "releases", :force => true do |t|
    t.string   "name",       :default => "",    :null => false
    t.boolean  "on_sale",    :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "titles", :force => true do |t|
    t.string   "title",       :default => ""
    t.text     "description", :default => ""
    t.string   "image_url",   :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "on_sale",     :default => true
    t.integer  "priority",    :default => 55
    t.string   "release",     :default => ""
  end

end
