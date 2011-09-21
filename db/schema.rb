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

ActiveRecord::Schema.define(:version => 20110920151634) do

  create_table "municipalities", :force => true do |t|
    t.integer  "id_ine"
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "municipalities", ["province_id"], :name => "index_municipalities_on_province_id"

  create_table "proposals", :force => true do |t|
    t.string   "name"
    t.string   "problem"
    t.string   "howto_solve"
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
  end

  create_table "provinces", :force => true do |t|
    t.integer  "id_ine"
    t.string   "name"
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
  end

  add_index "signatures", ["dni"], :name => "index_signatures_on_dni"
  add_index "signatures", ["proposal_id", "state"], :name => "index_signatures_on_proposal_id_and_state"

end
