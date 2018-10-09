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

ActiveRecord::Schema.define(version: 20181009031854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string "order_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "street_address_1"
    t.string "street_address_2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "phone"
    t.string "name"
    t.boolean "invoiced"
    t.string "reference_number"
    t.string "comments"
    t.boolean "notified"
  end

  create_table "quickbooks_credentials", force: :cascade do |t|
    t.string "access_token", limit: 1024
    t.string "refresh_token"
    t.string "realm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "radios", force: :cascade do |t|
    t.string "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shipment_id"
    t.string "pcb_version"
    t.string "serial_number"
    t.string "assembly_date"
    t.string "operator"
    t.boolean "boxed"
    t.string "country_code"
    t.string "firmware_version"
    t.string "quality_control_status"
  end

  create_table "shipments", force: :cascade do |t|
    t.string "tracking_number"
    t.string "ship_date"
    t.string "shipment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
    t.boolean "priority_processing"
    t.string "label_url"
    t.string "shipment_priority"
    t.string "return_label_url"
    t.string "shippo_reference_id"
    t.string "rate_reference_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
