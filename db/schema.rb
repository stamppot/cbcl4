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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181016131658) do

  create_table "answer_cells", force: true do |t|
    t.integer "answer_id",                default: 0, null: false
    t.integer "col",         limit: 2
    t.integer "row",         limit: 2
    t.string  "item",        limit: 5
    t.boolean "rating"
    t.string  "value_text",  limit: 2500
    t.boolean "text"
    t.integer "cell_type",   limit: 2
    t.integer "value",       limit: 2
    t.integer "question_id"
  end

  add_index "answer_cells", ["answer_id"], name: "index_answer_cells_on_answer_id", using: :btree

  create_table "answers", force: true do |t|
    t.integer "survey_answer_id", default: 0, null: false
    t.integer "number",           default: 0, null: false
    t.integer "question_id",      default: 0, null: false
    t.integer "ratings_count"
  end

  add_index "answers", ["question_id"], name: "fk_answers_questions", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["survey_answer_id"], name: "index_answers_on_survey_answer_id", using: :btree

  create_table "api_keys", force: true do |t|
    t.integer  "center_id"
    t.string   "name"
    t.string   "api_key"
    t.string   "salt",                   default: "4204533349928434450"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "return_to",  limit: 200
  end

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_type", "associated_id"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_type", "auditable_id", "version"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "center_infos", force: true do |t|
    t.integer "center_id"
    t.string  "street"
    t.string  "zipcode"
    t.string  "city"
    t.string  "telephone"
    t.string  "ean"
    t.string  "person"
  end

  add_index "center_infos", ["center_id"], name: "index_center_infos_on_center_id", using: :btree

  create_table "center_settings", force: true do |t|
    t.integer  "center_id"
    t.string   "settings"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", force: true do |t|
    t.string "name"
    t.string "full"
    t.string "options"
  end

  create_table "copies", force: true do |t|
    t.integer  "subscription_id", default: 0,     null: false
    t.integer  "used",            default: 0,     null: false
    t.boolean  "consolidated",    default: false
    t.date     "consolidated_on"
    t.date     "created_on"
    t.datetime "updated_on"
    t.boolean  "active",          default: false, null: false
  end

  create_table "csv_score_rapports", force: true do |t|
    t.integer  "journal_id"
    t.integer  "survey_answer_id"
    t.integer  "survey_id"
    t.integer  "team_id"
    t.integer  "center_id"
    t.integer  "age"
    t.integer  "sex"
    t.text     "answer"
    t.text     "variables"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answer_percentage", limit: 1
  end

  add_index "csv_score_rapports", ["age"], name: "index_csv_score_rapports_on_age", using: :btree
  add_index "csv_score_rapports", ["center_id"], name: "index_csv_score_rapports_on_center_id", using: :btree
  add_index "csv_score_rapports", ["survey_answer_id"], name: "index_csv_score_rapports_on_survey_answer_id", unique: true, using: :btree
  add_index "csv_score_rapports", ["team_id"], name: "index_csv_score_rapports_on_team_id", using: :btree

  create_table "csv_survey_answers", force: true do |t|
    t.integer  "journal_id"
    t.integer  "survey_answer_id"
    t.integer  "survey_id"
    t.integer  "journal_entry_id"
    t.integer  "team_id"
    t.integer  "center_id"
    t.integer  "age"
    t.integer  "sex"
    t.text     "answer"
    t.string   "journal_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answer_count",     default: 0
    t.integer  "follow_up",        default: 0
  end

  add_index "csv_survey_answers", ["age"], name: "index_csv_survey_answers_on_age", using: :btree
  add_index "csv_survey_answers", ["center_id"], name: "index_csv_survey_answers_on_center_id", using: :btree
  add_index "csv_survey_answers", ["survey_answer_id"], name: "index_csv_survey_answers_on_survey_answer_id", unique: true, using: :btree
  add_index "csv_survey_answers", ["team_id"], name: "index_csv_survey_answers_on_team_id", using: :btree

  create_table "engine_schema_info", id: false, force: true do |t|
    t.string  "engine_name"
    t.integer "version"
  end

  create_table "export_files", force: true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faq_sections", force: true do |t|
    t.string  "title"
    t.integer "position"
  end

  create_table "faqs", force: true do |t|
    t.integer "faq_section_id"
    t.integer "position"
    t.string  "question"
    t.string  "answer"
    t.string  "title"
  end

  add_index "faqs", ["faq_section_id"], name: "fk_faqs_faq_sections", using: :btree

  create_table "group_permissions", force: true do |t|
    t.integer "group_id"
    t.integer "permission_id"
  end

  create_table "groups", force: true do |t|
    t.timestamp "created_at",                            null: false
    t.timestamp "updated_at",                            null: false
    t.string    "title",      limit: 200, default: "",   null: false
    t.integer   "code"
    t.string    "type",       limit: 16,  default: "",   null: false
    t.integer   "parent_id"
    t.integer   "center_id"
    t.boolean   "delta",                  default: true, null: false
  end

  add_index "groups", ["center_id"], name: "groups_center_id_index", using: :btree
  add_index "groups", ["center_id"], name: "index_groups_on_center_id", using: :btree
  add_index "groups", ["code"], name: "index_groups_on_code", using: :btree
  add_index "groups", ["delta"], name: "index_groups_on_delta", using: :btree
  add_index "groups", ["parent_id"], name: "groups_parent_id_index", using: :btree
  add_index "groups", ["parent_id"], name: "index_groups_on_parent_id", using: :btree
  add_index "groups", ["type"], name: "index_groups_on_type", using: :btree

  create_table "groups_roles", id: false, force: true do |t|
    t.integer   "group_id",   default: 0, null: false
    t.integer   "role_id",    default: 0, null: false
    t.timestamp "created_at",             null: false
  end

  add_index "groups_roles", ["group_id", "role_id"], name: "groups_roles_all_index", unique: true, using: :btree
  add_index "groups_roles", ["role_id"], name: "role_id", using: :btree

  create_table "groups_users", id: false, force: true do |t|
    t.integer   "group_id",   default: 0, null: false
    t.integer   "user_id",    default: 0, null: false
    t.timestamp "created_at",             null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "groups_users_all_index", unique: true, using: :btree
  add_index "groups_users", ["user_id"], name: "user_id", using: :btree

  create_table "journal_click_counters", force: true do |t|
    t.integer  "user_id",                null: false
    t.integer  "journal_id",             null: false
    t.integer  "clicks",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "journal_entries", force: true do |t|
    t.integer  "journal_id",                   default: 0, null: false
    t.integer  "survey_id",                    default: 0, null: false
    t.integer  "user_id"
    t.string   "password"
    t.integer  "survey_answer_id"
    t.datetime "created_at"
    t.datetime "answered_at"
    t.integer  "state",                        default: 0, null: false
    t.datetime "updated_at"
    t.integer  "center_id"
    t.integer  "follow_up"
    t.integer  "group_id"
    t.integer  "reminder_status"
    t.string   "notes"
    t.string   "answer_info",      limit: 200
    t.integer  "next"
  end

  add_index "journal_entries", ["center_id"], name: "index_journal_entries_on_center_id", using: :btree
  add_index "journal_entries", ["group_id"], name: "index_journal_entries_on_group_id", using: :btree
  add_index "journal_entries", ["journal_id"], name: "index_journal_entries_on_journal_id", using: :btree
  add_index "journal_entries", ["state"], name: "index_journal_entries_on_state", using: :btree
  add_index "journal_entries", ["survey_answer_id"], name: "index_journal_entries_on_survey_answer_id", using: :btree
  add_index "journal_entries", ["survey_id"], name: "index_journal_entries_on_survey_id", using: :btree
  add_index "journal_entries", ["user_id"], name: "index_journal_entries_on_user_id", using: :btree

  create_table "journal_infos", force: true do |t|
    t.integer "journal_id"
    t.integer "center_id"
    t.integer "team_id"
    t.integer "pkoen"
    t.integer "palder"
    t.string  "ssghafd"
    t.string  "ssghnavn"
    t.string  "safdnavn"
    t.string  "pid"
    t.string  "pnation"
    t.date    "dagsdato"
    t.date    "pfoedt"
    t.string  "alt_id"
  end

  add_index "journal_infos", ["center_id"], name: "index_journal_infos_on_center_id", using: :btree
  add_index "journal_infos", ["journal_id"], name: "index_journal_infos_on_journal_id", unique: true, using: :btree
  add_index "journal_infos", ["team_id"], name: "index_journal_infos_on_team_id", using: :btree

  create_table "journals", force: true do |t|
    t.string   "title"
    t.integer  "code",         limit: 8
    t.integer  "group_id"
    t.integer  "center_id"
    t.integer  "delta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sex"
    t.date     "birthdate"
    t.string   "nationality"
    t.string   "cpr",          limit: 6
    t.string   "parent_email", limit: 50
    t.string   "parent_name",  limit: 60
    t.string   "alt_id",       limit: 30
    t.integer  "codenew",      limit: 8
    t.string   "notes",        limit: 1023
  end

  create_table "letters", force: true do |t|
    t.string   "type",        limit: 25, default: "LoginLetter", null: false
    t.integer  "group_id"
    t.string   "name"
    t.text     "letter"
    t.string   "surveytype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "follow_up"
    t.integer  "center_id"
    t.integer  "problematic"
    t.string   "sender",      limit: 50
    t.string   "bundle",      limit: 15
  end

  add_index "letters", ["group_id"], name: "index_letters_on_group_id", using: :btree

  create_table "nationalities", force: true do |t|
    t.string "country",      limit: 40
    t.string "country_code", limit: 4
  end

  create_table "periods", force: true do |t|
    t.integer  "subscription_id", default: 0,     null: false
    t.integer  "used",            default: 0,     null: false
    t.boolean  "paid",            default: false
    t.datetime "paid_on"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.boolean  "active",          default: false, null: false
    t.integer  "center_id",                       null: false
    t.integer  "survey_id",                       null: false
    t.datetime "start",                           null: false
  end

  add_index "periods", ["active"], name: "index_periods_on_active", using: :btree
  add_index "periods", ["paid"], name: "index_periods_on_paid", using: :btree
  add_index "periods", ["subscription_id"], name: "index_periods_on_subscription_id", using: :btree

  create_table "person_infos", force: true do |t|
    t.integer "journal_id",              default: 0,    null: false
    t.string  "name",                    default: "",   null: false
    t.integer "sex",                     default: 0,    null: false
    t.date    "birthdate",                              null: false
    t.string  "nationality",             default: "",   null: false
    t.string  "cpr"
    t.boolean "delta",                   default: true, null: false
    t.string  "parent_email"
    t.string  "alt_id",       limit: 50
    t.string  "parent_name"
  end

  add_index "person_infos", ["cpr"], name: "index_person_infos_on_cpr", using: :btree
  add_index "person_infos", ["delta"], name: "index_person_infos_on_delta", using: :btree
  add_index "person_infos", ["journal_id"], name: "index_person_infos_on_journal_id", using: :btree

  create_table "plugin_schema_info", id: false, force: true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_cells", force: true do |t|
    t.integer "question_id",                         null: false
    t.string  "type",         limit: 20
    t.integer "col"
    t.integer "row"
    t.string  "span",         limit: 7
    t.string  "answer_item",  limit: 5
    t.text    "items"
    t.string  "preferences"
    t.integer "prop_mask",               default: 0
    t.integer "choice_id"
    t.integer "problem_item", limit: 1
    t.integer "prespan",      limit: 1
  end

  add_index "question_cells", ["question_id"], name: "index_question_cells_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer "survey_id",                 null: false
    t.integer "number",                    null: false
    t.integer "ratings_count"
    t.integer "columns",       default: 3
    t.string  "preferences"
  end

  add_index "questions", ["survey_id"], name: "fk_questions_surveys", using: :btree

  create_table "roles", force: true do |t|
    t.string    "identifier", limit: 50,  default: "", null: false
    t.timestamp "created_at",                          null: false
    t.timestamp "updated_at",                          null: false
    t.string    "title",      limit: 100, default: "", null: false
    t.integer   "parent_id"
  end

  add_index "roles", ["parent_id"], name: "roles_parent_id_index", using: :btree

  create_table "roles_static_permissions", id: false, force: true do |t|
    t.integer   "role_id",              default: 0, null: false
    t.integer   "static_permission_id", default: 0, null: false
    t.timestamp "created_at",                       null: false
  end

  add_index "roles_static_permissions", ["role_id"], name: "role_id", using: :btree
  add_index "roles_static_permissions", ["static_permission_id", "role_id"], name: "roles_static_permissions_all_index", unique: true, using: :btree

  create_table "roles_users", id: false, force: true do |t|
    t.integer   "user_id",    default: 0, null: false
    t.integer   "role_id",    default: 0, null: false
    t.timestamp "created_at",             null: false
  end

  add_index "roles_users", ["role_id"], name: "role_id", using: :btree
  add_index "roles_users", ["user_id", "role_id"], name: "roles_users_all_index", unique: true, using: :btree

  create_table "schema_info", id: false, force: true do |t|
    t.integer "version"
  end

  create_table "score_groups", force: true do |t|
    t.string "title"
    t.text   "description"
  end

  create_table "score_items", force: true do |t|
    t.integer "score_id"
    t.integer "question_id"
    t.text    "items",       limit: 255
    t.string  "range"
    t.integer "qualifier"
    t.integer "number"
  end

  add_index "score_items", ["score_id"], name: "index_score_items_on_score_id", using: :btree

  create_table "score_rapports", force: true do |t|
    t.string   "title"
    t.string   "survey_name"
    t.string   "short_name"
    t.integer  "survey_id"
    t.integer  "survey_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unanswered"
    t.integer  "gender",                      null: false
    t.string   "age_group",         limit: 9
    t.integer  "age"
    t.integer  "center_id"
    t.integer  "follow_up"
    t.integer  "answer_percentage", limit: 2
  end

  create_table "score_refs", force: true do |t|
    t.integer "score_id"
    t.integer "gender"
    t.string  "age_group"
    t.float   "mean"
    t.integer "percent95"
    t.integer "percent98"
  end

  add_index "score_refs", ["score_id"], name: "index_score_refs_on_score_id", using: :btree

  create_table "score_results", force: true do |t|
    t.integer "score_rapport_id"
    t.integer "survey_id"
    t.integer "score_id"
    t.integer "result"
    t.integer "scale"
    t.string  "title"
    t.integer "position"
    t.float   "mean"
    t.boolean "deviation"
    t.boolean "percentile_98"
    t.boolean "percentile_95"
    t.integer "score_scale_id"
    t.integer "missing",            default: 0
    t.float   "missing_percentage"
    t.integer "hits"
    t.boolean "valid_percentage"
  end

  add_index "score_results", ["score_id", "score_rapport_id"], name: "index_score_results_on_score_id_and_score_rapport_id", using: :btree
  add_index "score_results", ["score_id"], name: "index_score_results_on_score_id", using: :btree
  add_index "score_results", ["score_rapport_id"], name: "index_score_results_on_score_rapport_id", using: :btree

  create_table "score_scales", force: true do |t|
    t.integer "position"
    t.string  "title"
  end

  create_table "scores", force: true do |t|
    t.integer  "score_group_id"
    t.integer  "survey_id"
    t.string   "title"
    t.string   "short_name"
    t.integer  "sum"
    t.integer  "scale"
    t.integer  "position"
    t.integer  "score_scale_id"
    t.integer  "items_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "variable"
    t.string   "datatype",       default: "Numeric"
  end

  add_index "scores", ["score_group_id"], name: "fk_scores_score_groups", using: :btree
  add_index "scores", ["survey_id"], name: "fk_scores_surveys", using: :btree

  create_table "scores_surveys", id: false, force: true do |t|
    t.integer "score_id"
    t.integer "survey_id"
  end

  add_index "scores_surveys", ["score_id"], name: "index_scores_surveys_on_score_id", using: :btree
  add_index "scores_surveys", ["survey_id"], name: "index_scores_surveys_on_survey_id", using: :btree

  create_table "sph_counter", id: false, force: true do |t|
    t.integer "last_id",               null: false
    t.string  "table_name", limit: 50, null: false
  end

  create_table "static_permissions", force: true do |t|
    t.string    "identifier", limit: 50,  default: "", null: false
    t.string    "title",      limit: 200, default: "", null: false
    t.timestamp "created_at",                          null: false
    t.timestamp "updated_at",                          null: false
  end

  add_index "static_permissions", ["title"], name: "static_permissions_title_index", unique: true, using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "center_id",           default: 0, null: false
    t.integer  "survey_id",           default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",               default: 0, null: false
    t.text     "note"
    t.integer  "total_used"
    t.integer  "total_paid"
    t.integer  "active_used"
    t.datetime "most_recent_payment"
    t.datetime "start"
  end

  add_index "subscriptions", ["center_id"], name: "index_subscriptions_on_center_id", using: :btree
  add_index "subscriptions", ["survey_id"], name: "index_subscriptions_on_survey_id", using: :btree

  create_table "survey_answers", force: true do |t|
    t.integer  "survey_id",                   default: 0,     null: false
    t.string   "surveytype",       limit: 15
    t.string   "answered_by",      limit: 15
    t.datetime "created_at"
    t.integer  "age",                         default: 0,     null: false
    t.integer  "sex",                         default: 0,     null: false
    t.string   "nationality",      limit: 24
    t.integer  "journal_entry_id",            default: 0,     null: false
    t.boolean  "done",                        default: false
    t.datetime "updated_at"
    t.integer  "journal_id"
    t.integer  "center_id"
    t.integer  "team_id"
    t.string   "alt_id"
    t.integer  "follow_up",                   default: 0
  end

  add_index "survey_answers", ["age"], name: "index_survey_answers_on_age", using: :btree
  add_index "survey_answers", ["center_id"], name: "index_survey_answers_on_center_id", using: :btree
  add_index "survey_answers", ["done"], name: "index_survey_answers_on_done", using: :btree
  add_index "survey_answers", ["journal_entry_id"], name: "index_survey_answers_on_journal_entry_id", using: :btree
  add_index "survey_answers", ["journal_id"], name: "index_survey_answers_on_journal_id", using: :btree
  add_index "survey_answers", ["survey_id"], name: "index_survey_answers_on_survey_id", using: :btree

  create_table "survey_usage_logs", force: true do |t|
    t.integer   "survey_id",        null: false
    t.integer   "user_id",          null: false
    t.integer   "group_id",         null: false
    t.integer   "center_id",        null: false
    t.timestamp "created_at",       null: false
    t.integer   "survey_answer_id", null: false
  end

  create_table "surveys", force: true do |t|
    t.string  "title",       limit: 40
    t.string  "category"
    t.text    "description"
    t.string  "age"
    t.string  "surveytype",  limit: 15
    t.string  "color",       limit: 7
    t.integer "position",               default: 99
    t.string  "prefix"
    t.string  "bundle",      limit: 10
  end

  create_table "task_logs", force: true do |t|
    t.string    "name",       limit: 31, default: "", null: false
    t.string    "message",               default: "", null: false
    t.integer   "group_id",                           null: false
    t.integer   "journal_id"
    t.string    "param1",     limit: 50
    t.string    "param2",     limit: 50
    t.timestamp "created_at",                         null: false
    t.integer   "task_id"
  end

  create_table "tasks", force: true do |t|
    t.string   "type",             limit: 31
    t.string   "status"
    t.integer  "export_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_answer_id"
    t.integer  "group_id"
    t.integer  "journal_id"
    t.integer  "letter_id"
    t.string   "param1"
  end

  create_table "user_registrations", force: true do |t|
    t.integer   "user_id",    default: 0, null: false
    t.text      "token",                  null: false
    t.timestamp "created_at",             null: false
    t.timestamp "expires_at",             null: false
  end

  add_index "user_registrations", ["expires_at"], name: "user_registrations_expires_at_index", using: :btree
  add_index "user_registrations", ["user_id"], name: "user_registrations_user_id_index", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.timestamp "created_at",                                             null: false
    t.timestamp "updated_at",                                             null: false
    t.timestamp "last_logged_in_at",                                      null: false
    t.integer   "login_failure_count",             default: 0,            null: false
    t.string    "login",               limit: 100, default: "",           null: false
    t.string    "name",                limit: 100, default: "",           null: false
    t.string    "email",               limit: 200, default: "",           null: false
    t.string    "password",            limit: 128, default: "",           null: false
    t.string    "password_hash_type",  limit: 10,  default: "",           null: false
    t.string    "password_salt",       limit: 100, default: "1234512345", null: false
    t.integer   "state",                           default: 1,            null: false
    t.integer   "center_id"
    t.boolean   "login_user",                      default: false
    t.integer   "delta"
    t.string    "role_ids_str"
  end

  add_index "users", ["center_id"], name: "users_center_id_index", using: :btree
  add_index "users", ["login"], name: "users_login_index", unique: true, using: :btree
  add_index "users", ["password"], name: "users_password_index", using: :btree

  create_table "variables", force: true do |t|
    t.string   "var"
    t.string   "item"
    t.integer  "row"
    t.integer  "col"
    t.integer  "survey_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "datatype"
  end

  add_index "variables", ["col"], name: "index_variables_on_col", using: :btree
  add_index "variables", ["question_id"], name: "fk_variables_questions", using: :btree
  add_index "variables", ["question_id"], name: "index_variables_on_question_id", using: :btree
  add_index "variables", ["row"], name: "index_variables_on_row", using: :btree
  add_index "variables", ["survey_id"], name: "fk_variables_surveys", using: :btree

end
