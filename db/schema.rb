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

ActiveRecord::Schema.define(:version => 20130829094253) do

  create_table "admin_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true

  create_table "elections", :force => true do |t|
    t.string   "name"
    t.date     "signatures_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "endorsment_proposals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "endorsment_signatures", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedback_signatures", :force => true do |t|
    t.integer  "reason_feedback_id"
    t.integer  "signature_id"
    t.integer  "proposal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "municipalities", :force => true do |t|
    t.integer  "id_ine"
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "municipalities", ["province_id"], :name => "index_municipalities_on_province_id"

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.string   "tractis_template_code"
    t.string   "pdf_file_name"
    t.string   "pdf_content_type"
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.integer  "num_required_signatures"
    t.string   "promoter_name"
    t.string   "promoter_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "handwritten_signatures"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "promoter_short_name"
    t.date     "signatures_end_date"
    t.string   "type"
    t.text     "howto_solve"
    t.string   "election_type"
    t.text     "problem"
    t.integer  "election_id"
    t.string   "attestor_template_code"
    t.integer  "user_id"
    t.string   "ilp_code"
    t.string   "subtype"
    t.string   "subtype_provinces"
  end

  create_table "provinces", :force => true do |t|
    t.integer  "id_ine"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "only_circunscription"
  end

  create_table "reason_feedbacks", :force => true do |t|
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", :force => true do |t|
    t.integer  "proposal_id"
    t.string   "email"
    t.integer  "state"
    t.string   "token"
    t.string   "tractis_contract_location"
    t.string   "name"
    t.string   "dni"
    t.string   "surname"
    t.boolean  "terms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "province_id"
    t.integer  "municipality_id"
    t.string   "address"
    t.string   "zipcode"
    t.date     "date_of_birth"
    t.integer  "province_of_birth_id"
    t.integer  "municipality_of_birth_id"
    t.string   "type"
    t.string   "surname2"
    t.string   "tractis_signature_file_name"
    t.string   "tractis_signature_content_type"
    t.integer  "tractis_signature_file_size"
    t.datetime "tractis_signature_updated_at"
    t.string   "telephone"
    t.integer  "number_of_sheets"
    t.boolean  "unsubscribe"
  end

  add_index "signatures", ["dni"], :name => "index_signatures_on_dni"
  add_index "signatures", ["proposal_id", "state"], :name => "index_signatures_on_proposal_id_and_state"
  add_index "signatures", ["token"], :name => "index_signatures_on_token"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "terms"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
