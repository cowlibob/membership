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

ActiveRecord::Schema[8.0].define(version: 2024_12_13_221657) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace", limit: 255
    t.text "body"
    t.string "resource_id", limit: 255, null: false
    t.string "resource_type", limit: 255, null: false
    t.integer "author_id"
    t.string "author_type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "boats", id: :serial, force: :cascade do |t|
    t.string "classname", limit: 255
    t.string "sail_number", limit: 255
    t.string "hull_colour", limit: 255
    t.boolean "berthing"
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "renewal_id"
    t.boolean "is_sailboard", default: false
  end

  create_table "contents", id: :serial, force: :cascade do |t|
    t.string "tag", limit: 255
    t.text "content"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["tag"], name: "index_contents_on_tag", unique: true
  end

  create_table "csv_exports", force: :cascade do |t|
    t.integer "year"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "export_type", default: "renewal"
  end

  create_table "duties", id: :serial, force: :cascade do |t|
    t.integer "renewal_id"
    t.date "thursday"
    t.date "saturday"
    t.date "sunday"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "preference", limit: 255, default: "request"
  end

  create_table "members", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "phone", limit: 255
    t.string "email", limit: 255
    t.date "dob"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "renewal_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "renewal_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "renewals", id: :serial, force: :cascade do |t|
    t.string "membership_class", limit: 255
    t.string "address_1", limit: 255
    t.string "address_2", limit: 255
    t.string "postcode", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "comment"
    t.string "reference", limit: 255
    t.datetime "payment_confirmed_at", precision: nil
    t.boolean "insurance_confirmed", default: false
    t.boolean "share_data_for_commission", default: false
    t.boolean "declaration_confirmed", default: false
    t.text "emergency_contact_details"
    t.string "token"
    t.integer "payemnt_id"
    t.integer "one_hundred_club_tickets", default: 0
    t.index ["token"], name: "index_renewals_on_token"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end
end
