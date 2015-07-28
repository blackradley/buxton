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

ActiveRecord::Schema.define(version: 20150728112117) do

  create_table "activities", force: :cascade do |t|
    t.string   "name",                                limit: 255
    t.integer  "activity_status",                     limit: 4
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "updated_by",                          limit: 255
    t.integer  "activity_type",                       limit: 4,     default: 0
    t.datetime "approved_on"
    t.boolean  "purpose_completed",                                 default: false
    t.boolean  "impact_completed",                                  default: false
    t.boolean  "consultation_completed",                            default: false
    t.boolean  "additional_work_completed",                         default: false
    t.boolean  "action_planning_completed",                         default: false
    t.boolean  "use_purpose_completed",                             default: true
    t.boolean  "gender_relevant"
    t.boolean  "sexual_orientation_relevant"
    t.boolean  "age_relevant"
    t.boolean  "faith_relevant"
    t.boolean  "disability_relevant"
    t.boolean  "race_relevant"
    t.date     "review_on"
    t.integer  "activity_project_id",                 limit: 4
    t.integer  "completer_id",                        limit: 4
    t.integer  "approver_id",                         limit: 4
    t.integer  "service_area_id",                     limit: 4
    t.boolean  "approved"
    t.boolean  "submitted"
    t.boolean  "gender_reassignment_relevant"
    t.boolean  "pregnancy_and_maternity_relevant"
    t.boolean  "marriage_civil_partnership_relevant"
    t.date     "actual_start_date"
    t.boolean  "ready"
    t.text     "summary",                             limit: 65535
    t.boolean  "is_rejected",                                       default: false
    t.integer  "qc_officer_id",                       limit: 4
    t.boolean  "undergone_qc",                                      default: false
    t.integer  "previous_activity_id",                limit: 4
    t.string   "ref_no",                              limit: 255
    t.boolean  "recently_rejected",                                 default: false
  end

  create_table "activities_projects", id: false, force: :cascade do |t|
    t.integer "activity_id", limit: 4
    t.integer "project_id",  limit: 4
  end

  add_index "activities_projects", ["activity_id"], name: "index_activities_projects_on_activity_id", using: :btree
  add_index "activities_projects", ["project_id"], name: "index_activities_projects_on_project_id", using: :btree

  create_table "activity_strategies", force: :cascade do |t|
    t.integer "activity_id",       limit: 4
    t.integer "strategy_id",       limit: 4
    t.integer "strategy_response", limit: 4
  end

  add_index "activity_strategies", ["activity_id"], name: "index_activity_strategies_on_activity_id", using: :btree
  add_index "activity_strategies", ["strategy_id"], name: "index_activity_strategies_on_strategy_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "question_id",          limit: 4
    t.text     "contents",             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_strategy_id", limit: 4
  end

  add_index "comments", ["activity_strategy_id"], name: "index_comments_on_activity_strategy_id", using: :btree
  add_index "comments", ["question_id"], name: "index_comments_on_question_id", using: :btree

  create_table "dependencies", force: :cascade do |t|
    t.integer "question_id",       limit: 4
    t.integer "child_question_id", limit: 4
    t.integer "required_value",    limit: 4
  end

  add_index "dependencies", ["question_id"], name: "index_dependencies_on_question_id", using: :btree

  create_table "directorates", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_on"
    t.datetime "updated_on"
    t.boolean  "retired",                default: false
    t.integer  "creator_id", limit: 4
  end

  create_table "directorates_users", id: false, force: :cascade do |t|
    t.integer "directorate_id", limit: 4
    t.integer "user_id",        limit: 4
  end

  create_table "function_strategies", force: :cascade do |t|
    t.integer "function_id",       limit: 4
    t.integer "strategy_id",       limit: 4
    t.integer "strategy_response", limit: 4
  end

  create_table "functions", force: :cascade do |t|
    t.integer  "function_manager_id",                  limit: 4
    t.integer  "organisation_id",                      limit: 4
    t.string   "name",                                 limit: 255
    t.integer  "existing_proposed",                    limit: 4,     default: 0
    t.integer  "purpose_overall_5",                    limit: 4,     default: 0
    t.integer  "purpose_overall_6",                    limit: 4,     default: 0
    t.integer  "purpose_overall_7",                    limit: 4,     default: 0
    t.integer  "purpose_overall_8",                    limit: 4,     default: 0
    t.integer  "purpose_overall_9",                    limit: 4,     default: 0
    t.integer  "purpose_gender_3",                     limit: 4,     default: 0
    t.integer  "purpose_race_3",                       limit: 4,     default: 0
    t.integer  "purpose_disability_3",                 limit: 4,     default: 0
    t.integer  "purpose_faith_3",                      limit: 4,     default: 0
    t.integer  "purpose_sexual_orientation_3",         limit: 4,     default: 0
    t.integer  "purpose_age_3",                        limit: 4,     default: 0
    t.integer  "purpose_gender_4",                     limit: 4,     default: 0
    t.integer  "purpose_race_4",                       limit: 4,     default: 0
    t.integer  "purpose_disability_4",                 limit: 4,     default: 0
    t.integer  "purpose_faith_4",                      limit: 4,     default: 0
    t.integer  "purpose_sexual_orientation_4",         limit: 4,     default: 0
    t.integer  "purpose_age_4",                        limit: 4,     default: 0
    t.integer  "approved",                             limit: 4,     default: 0
    t.string   "approver",                             limit: 255
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "updated_by",                           limit: 255
    t.integer  "impact_overall_1",                     limit: 4,     default: 0
    t.integer  "impact_overall_2",                     limit: 4,     default: 0
    t.string   "impact_overall_3",                     limit: 255
    t.integer  "impact_overall_4",                     limit: 4,     default: 0
    t.text     "impact_overall_5",                     limit: 65535
    t.integer  "impact_gender_1",                      limit: 4,     default: 0
    t.integer  "impact_gender_2",                      limit: 4,     default: 0
    t.string   "impact_gender_3",                      limit: 255
    t.integer  "impact_gender_4",                      limit: 4,     default: 0
    t.text     "impact_gender_5",                      limit: 65535
    t.integer  "impact_race_1",                        limit: 4,     default: 0
    t.integer  "impact_race_2",                        limit: 4,     default: 0
    t.string   "impact_race_3",                        limit: 255
    t.integer  "impact_race_4",                        limit: 4,     default: 0
    t.text     "impact_race_5",                        limit: 65535
    t.integer  "impact_disability_1",                  limit: 4,     default: 0
    t.integer  "impact_disability_2",                  limit: 4,     default: 0
    t.string   "impact_disability_3",                  limit: 255
    t.integer  "impact_disability_4",                  limit: 4,     default: 0
    t.text     "impact_disability_5",                  limit: 65535
    t.integer  "impact_faith_1",                       limit: 4,     default: 0
    t.integer  "impact_faith_2",                       limit: 4,     default: 0
    t.string   "impact_faith_3",                       limit: 255
    t.integer  "impact_faith_4",                       limit: 4,     default: 0
    t.text     "impact_faith_5",                       limit: 65535
    t.integer  "impact_sexual_orientation_1",          limit: 4,     default: 0
    t.integer  "impact_sexual_orientation_2",          limit: 4,     default: 0
    t.string   "impact_sexual_orientation_3",          limit: 255
    t.integer  "impact_sexual_orientation_4",          limit: 4,     default: 0
    t.text     "impact_sexual_orientation_5",          limit: 65535
    t.integer  "impact_age_1",                         limit: 4,     default: 0
    t.integer  "impact_age_2",                         limit: 4,     default: 0
    t.string   "impact_age_3",                         limit: 255
    t.integer  "impact_age_4",                         limit: 4,     default: 0
    t.text     "impact_age_5",                         limit: 65535
    t.integer  "impact_overall_6",                     limit: 4,     default: 0
    t.integer  "impact_overall_7",                     limit: 4,     default: 0
    t.integer  "impact_overall_8",                     limit: 4,     default: 0
    t.integer  "impact_overall_9",                     limit: 4,     default: 0
    t.text     "impact_overall_10",                    limit: 65535
    t.integer  "impact_gender_6",                      limit: 4,     default: 0
    t.integer  "impact_gender_7",                      limit: 4,     default: 0
    t.integer  "impact_gender_8",                      limit: 4,     default: 0
    t.integer  "impact_gender_9",                      limit: 4,     default: 0
    t.text     "impact_gender_10",                     limit: 65535
    t.integer  "impact_race_6",                        limit: 4,     default: 0
    t.integer  "impact_race_7",                        limit: 4,     default: 0
    t.integer  "impact_race_8",                        limit: 4,     default: 0
    t.integer  "impact_race_9",                        limit: 4,     default: 0
    t.text     "impact_race_10",                       limit: 65535
    t.integer  "impact_disability_6",                  limit: 4,     default: 0
    t.integer  "impact_disability_7",                  limit: 4,     default: 0
    t.integer  "impact_disability_8",                  limit: 4,     default: 0
    t.integer  "impact_disability_9",                  limit: 4,     default: 0
    t.text     "impact_disability_10",                 limit: 65535
    t.integer  "impact_faith_6",                       limit: 4,     default: 0
    t.integer  "impact_faith_7",                       limit: 4,     default: 0
    t.integer  "impact_faith_8",                       limit: 4,     default: 0
    t.integer  "impact_faith_9",                       limit: 4,     default: 0
    t.text     "impact_faith_10",                      limit: 65535
    t.integer  "impact_sexual_orientation_6",          limit: 4,     default: 0
    t.integer  "impact_sexual_orientation_7",          limit: 4,     default: 0
    t.integer  "impact_sexual_orientation_8",          limit: 4,     default: 0
    t.integer  "impact_sexual_orientation_9",          limit: 4,     default: 0
    t.text     "impact_sexual_orientation_10",         limit: 65535
    t.integer  "impact_age_6",                         limit: 4,     default: 0
    t.integer  "impact_age_7",                         limit: 4,     default: 0
    t.integer  "impact_age_8",                         limit: 4,     default: 0
    t.integer  "impact_age_9",                         limit: 4,     default: 0
    t.text     "impact_age_10",                        limit: 65535
    t.integer  "consultation_gender_2",                limit: 4,     default: 0
    t.text     "consultation_gender_3",                limit: 65535
    t.integer  "consultation_gender_4",                limit: 4,     default: 0
    t.integer  "consultation_gender_5",                limit: 4,     default: 0
    t.text     "consultation_gender_6",                limit: 65535
    t.integer  "consultation_gender_7",                limit: 4,     default: 0
    t.integer  "consultation_race_1",                  limit: 4,     default: 0
    t.integer  "consultation_race_2",                  limit: 4,     default: 0
    t.text     "consultation_race_3",                  limit: 65535
    t.integer  "consultation_race_4",                  limit: 4,     default: 0
    t.integer  "consultation_race_5",                  limit: 4,     default: 0
    t.text     "consultation_race_6",                  limit: 65535
    t.integer  "consultation_race_7",                  limit: 4,     default: 0
    t.integer  "consultation_disability_1",            limit: 4,     default: 0
    t.integer  "consultation_disability_2",            limit: 4,     default: 0
    t.text     "consultation_disability_3",            limit: 65535
    t.integer  "consultation_disability_4",            limit: 4,     default: 0
    t.integer  "consultation_disability_5",            limit: 4,     default: 0
    t.text     "consultation_disability_6",            limit: 65535
    t.integer  "consultation_disability_7",            limit: 4,     default: 0
    t.integer  "consultation_faith_1",                 limit: 4,     default: 0
    t.integer  "consultation_faith_2",                 limit: 4,     default: 0
    t.text     "consultation_faith_3",                 limit: 65535
    t.integer  "consultation_faith_4",                 limit: 4,     default: 0
    t.integer  "consultation_faith_5",                 limit: 4,     default: 0
    t.text     "consultation_faith_6",                 limit: 65535
    t.integer  "consultation_faith_7",                 limit: 4,     default: 0
    t.integer  "consultation_sexual_orientation_1",    limit: 4,     default: 0
    t.integer  "consultation_sexual_orientation_2",    limit: 4,     default: 0
    t.text     "consultation_sexual_orientation_3",    limit: 65535
    t.integer  "consultation_sexual_orientation_4",    limit: 4,     default: 0
    t.integer  "consultation_sexual_orientation_5",    limit: 4,     default: 0
    t.text     "consultation_sexual_orientation_6",    limit: 65535
    t.integer  "consultation_sexual_orientation_7",    limit: 4,     default: 0
    t.integer  "consultation_age_1",                   limit: 4,     default: 0
    t.integer  "consultation_age_2",                   limit: 4,     default: 0
    t.text     "consultation_age_3",                   limit: 65535
    t.integer  "consultation_age_4",                   limit: 4,     default: 0
    t.integer  "consultation_age_5",                   limit: 4,     default: 0
    t.text     "consultation_age_6",                   limit: 65535
    t.integer  "consultation_age_7",                   limit: 4,     default: 0
    t.text     "purpose_overall_2",                    limit: 65535
    t.integer  "consultation_gender_1",                limit: 4,     default: 0
    t.integer  "additional_work_gender_1",             limit: 4,     default: 0
    t.text     "additional_work_gender_2",             limit: 65535
    t.integer  "additional_work_gender_3",             limit: 4,     default: 0
    t.integer  "additional_work_gender_4",             limit: 4,     default: 0
    t.integer  "additional_work_gender_5",             limit: 4,     default: 0
    t.integer  "additional_work_gender_6",             limit: 4,     default: 0
    t.integer  "additional_work_race_1",               limit: 4,     default: 0
    t.text     "additional_work_race_2",               limit: 65535
    t.integer  "additional_work_race_3",               limit: 4,     default: 0
    t.integer  "additional_work_race_4",               limit: 4,     default: 0
    t.integer  "additional_work_race_5",               limit: 4,     default: 0
    t.integer  "additional_work_race_6",               limit: 4,     default: 0
    t.integer  "additional_work_race_7",               limit: 4,     default: 0
    t.integer  "additional_work_disability_1",         limit: 4,     default: 0
    t.text     "additional_work_disability_2",         limit: 65535
    t.integer  "additional_work_disability_3",         limit: 4,     default: 0
    t.integer  "additional_work_disability_4",         limit: 4,     default: 0
    t.integer  "additional_work_disability_5",         limit: 4,     default: 0
    t.integer  "additional_work_disability_6",         limit: 4,     default: 0
    t.integer  "additional_work_disability_7",         limit: 4,     default: 0
    t.integer  "additional_work_disability_8",         limit: 4,     default: 0
    t.integer  "additional_work_sexual_orientation_1", limit: 4,     default: 0
    t.text     "additional_work_sexual_orientation_2", limit: 65535
    t.integer  "additional_work_sexual_orientation_3", limit: 4,     default: 0
    t.integer  "additional_work_sexual_orientation_4", limit: 4,     default: 0
    t.integer  "additional_work_sexual_orientation_5", limit: 4,     default: 0
    t.integer  "additional_work_sexual_orientation_6", limit: 4,     default: 0
    t.integer  "additional_work_sexual_orientation_7", limit: 4,     default: 0
    t.integer  "additional_work_age_1",                limit: 4,     default: 0
    t.text     "additional_work_age_2",                limit: 65535
    t.integer  "additional_work_age_3",                limit: 4,     default: 0
    t.integer  "additional_work_age_4",                limit: 4,     default: 0
    t.integer  "additional_work_age_5",                limit: 4,     default: 0
    t.integer  "additional_work_age_6",                limit: 4,     default: 0
    t.integer  "additional_work_age_7",                limit: 4,     default: 0
    t.integer  "additional_work_faith_1",              limit: 4,     default: 0
    t.text     "additional_work_faith_2",              limit: 65535
    t.integer  "additional_work_faith_3",              limit: 4,     default: 0
    t.integer  "additional_work_faith_4",              limit: 4,     default: 0
    t.integer  "additional_work_faith_5",              limit: 4,     default: 0
    t.integer  "additional_work_faith_6",              limit: 4,     default: 0
    t.integer  "additional_work_faith_7",              limit: 4,     default: 0
    t.integer  "additional_work_disability_9",         limit: 4,     default: 0
    t.integer  "additional_work_disability_10",        limit: 4,     default: 0
    t.integer  "function_policy",                      limit: 4,     default: 0
    t.integer  "directorate_id",                       limit: 4
  end

  create_table "help_texts", force: :cascade do |t|
    t.string   "question_name",     limit: 40
    t.text     "existing_function", limit: 65535
    t.text     "existing_policy",   limit: 65535
    t.text     "proposed_function", limit: 65535
    t.text     "proposed_policy",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "help_texts", ["question_name"], name: "index_help_texts_on_question_name", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer "activity_id",     limit: 4
    t.text    "description",     limit: 65535
    t.text    "actions",         limit: 65535
    t.text    "resources",       limit: 65535
    t.string  "strand",          limit: 255
    t.text    "section",         limit: 65535
    t.text    "recommendations", limit: 65535
    t.text    "monitoring",      limit: 65535
    t.text    "outcomes",        limit: 65535
    t.integer "parent_issue_id", limit: 4
    t.date    "timescales"
    t.integer "lead_officer_id", limit: 4
    t.date    "completing"
  end

  add_index "issues", ["activity_id"], name: "index_issues_on_activity_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.string   "message",     limit: 255
    t.datetime "created_at"
    t.integer  "activity_id", limit: 4
    t.integer  "user_id",     limit: 4
  end

  create_table "look_ups", force: :cascade do |t|
    t.integer "look_up_type", limit: 4
    t.string  "name",         limit: 255
    t.integer "value",        limit: 4
    t.integer "weight",       limit: 4
    t.string  "description",  limit: 255
    t.integer "position",     limit: 4
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "question_id",          limit: 4
    t.text     "contents",             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_strategy_id", limit: 4
  end

  add_index "notes", ["activity_strategy_id"], name: "index_notes_on_activity_strategy_id", using: :btree
  add_index "notes", ["question_id"], name: "index_notes_on_question_id", using: :btree

  create_table "organisation_terminologies", force: :cascade do |t|
    t.integer  "organisation_id", limit: 4
    t.integer  "terminology_id",  limit: 4
    t.string   "value",           limit: 255, default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organisation_terminologies", ["organisation_id"], name: "index_organisation_terminologies_on_organisation_id", using: :btree
  add_index "organisation_terminologies", ["terminology_id"], name: "index_organisation_terminologies_on_terminology_id", using: :btree

  create_table "organisations", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "strategy_text_selection", limit: 4,   default: 0
    t.string   "ces_link",                limit: 255
    t.string   "ces_term",                limit: 255, default: "Corporate Equality Scheme"
    t.string   "subdomain",               limit: 255, default: "www"
    t.boolean  "trial",                               default: false,                       null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "organisation_id",     limit: 4
    t.string   "name",                limit: 255
    t.integer  "activity_project_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["organisation_id"], name: "index_projects_on_organisation_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "activity_id",   limit: 4
    t.string   "name",          limit: 255
    t.boolean  "completed",                   default: false
    t.boolean  "needed",                      default: false
    t.text     "raw_answer",    limit: 65535
    t.text     "choices",       limit: 65535
    t.string   "input_type",    limit: 255
    t.string   "section",       limit: 255
    t.string   "strand",        limit: 255
    t.integer  "dependency_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_label",     limit: 65535
    t.text     "raw_help_text", limit: 65535
  end

  add_index "questions", ["activity_id", "name", "needed", "completed"], name: "index_questions_on_activity_id_and_name_and_needed_and_completed", using: :btree
  add_index "questions", ["activity_id", "name"], name: "activity_and_question_name", unique: true, using: :btree
  add_index "questions", ["activity_id"], name: "index_questions_on_activity_id", using: :btree

  create_table "service_areas", force: :cascade do |t|
    t.integer "directorate_id", limit: 4
    t.integer "approver_id",    limit: 4
    t.string  "name",           limit: 255
    t.boolean "retired",                    default: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255
    t.text     "data",       limit: 65535
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "strategies", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_on"
    t.datetime "updated_on"
    t.boolean  "retired",                   default: false
  end

  create_table "task_group_memberships", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "activity_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terminologies", force: :cascade do |t|
    t.string   "term",       limit: 255, default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 128, default: "",    null: false
    t.string   "password_salt",          limit: 255, default: "",    null: false
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                   limit: 255
    t.boolean  "retired",                            default: false
    t.boolean  "locked"
    t.boolean  "creator",                            default: false
    t.integer  "failed_attempts",        limit: 4,   default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.boolean  "trained",                            default: true
    t.string   "reset_password_token",   limit: 255
    t.boolean  "corporate_cop"
    t.datetime "password_changed_at"
    t.date     "reset_password_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
