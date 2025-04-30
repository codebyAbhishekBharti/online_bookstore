# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_04_30_121616) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "full_name"
    t.string "phone_number"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.boolean "is_default"
    t.string "address_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "address_line1", "city", "zip_code"], name: "unique_user_address", unique: true
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.decimal "price"
    t.text "description"
    t.integer "stock_quantity"
    t.string "category_name"
    t.integer "vendor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title", "vendor_id"], name: "index_books_on_title_and_vendor_id", unique: true
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_carts_on_book_id"
    t.index ["user_id", "book_id"], name: "index_carts_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_group_id", null: false
    t.bigint "book_id", null: false
    t.integer "quantity", null: false
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_order_items_on_book_id"
    t.index ["order_group_id"], name: "index_order_items_on_order_group_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "order_group_id"
    t.decimal "total_amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shipment_address_id", null: false
    t.index ["order_group_id"], name: "index_orders_on_order_group_id", unique: true
    t.index ["shipment_address_id"], name: "index_orders_on_shipment_address_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "shipment_addresses", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "phone_number"
    t.text "address"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "books", "users", column: "vendor_id"
  add_foreign_key "carts", "books"
  add_foreign_key "carts", "users"
  add_foreign_key "order_items", "books"
  add_foreign_key "order_items", "orders", column: "order_group_id", primary_key: "order_group_id"
  add_foreign_key "orders", "shipment_addresses"
  add_foreign_key "orders", "users"
end
