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

ActiveRecord::Schema.define(:version => 20120515110303) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.integer  "activity_status"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "updated_by"
    t.integer  "activity_type",                       :default => 0
    t.datetime "approved_on"
    t.boolean  "purpose_completed",                   :default => false
    t.boolean  "impact_completed",                    :default => false
    t.boolean  "consultation_completed",              :default => false
    t.boolean  "additional_work_completed",           :default => false
    t.boolean  "action_planning_completed",           :default => false
    t.boolean  "use_purpose_completed",               :default => true
    t.boolean  "gender_relevant"
    t.boolean  "sexual_orientation_relevant"
    t.boolean  "age_relevant"
    t.boolean  "faith_relevant"
    t.boolean  "disability_relevant"
    t.boolean  "race_relevant"
    t.date     "review_on"
    t.integer  "activity_project_id"
    t.integer  "completer_id"
    t.integer  "approver_id"
    t.integer  "service_area_id"
    t.boolean  "approved"
    t.boolean  "submitted"
    t.boolean  "gender_reassignment_relevant"
    t.boolean  "pregnancy_and_maternity_relevant"
    t.boolean  "marriage_civil_partnership_relevant"
    t.date     "actual_start_date"
    t.boolean  "ready"
    t.text     "summary"
    t.boolean  "is_rejected",                         :default => false
    t.integer  "qc_officer_id"
    t.boolean  "undergone_qc",                        :default => false
    t.integer  "previous_activity_id"
    t.string   "ref_no"
    t.boolean  "recently_rejected",                   :default => false
  end

  create_table "activities_projects", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "project_id"
  end

  add_index "activities_projects", ["activity_id"], :name => "index_activities_projects_on_activity_id"
  add_index "activities_projects", ["project_id"], :name => "index_activities_projects_on_project_id"

  create_table "activity_strategies", :force => true do |t|
    t.integer "activity_id"
    t.integer "strategy_id"
    t.integer "strategy_response"
  end

  add_index "activity_strategies", ["activity_id"], :name => "index_activity_strategies_on_activity_id"
  add_index "activity_strategies", ["strategy_id"], :name => "index_activity_strategies_on_strategy_id"

  create_table "comments", :force => true do |t|
    t.integer  "question_id"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_strategy_id"
  end

  add_index "comments", ["activity_strategy_id"], :name => "index_comments_on_activity_strategy_id"
  add_index "comments", ["question_id"], :name => "index_comments_on_question_id"

  create_table "dependencies", :force => true do |t|
    t.integer "question_id"
    t.integer "child_question_id"
    t.integer "required_value"
  end

  add_index "dependencies", ["question_id"], :name => "index_dependencies_on_question_id"

  create_table "directorates", :force => true do |t|
    t.string   "name"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "cop_id"
    t.boolean  "retired",    :default => false
    t.integer  "creator_id"
  end

  create_table "function_strategies", :force => true do |t|
    t.integer "function_id"
    t.integer "strategy_id"
    t.integer "strategy_response"
  end

  create_table "functions", :force => true do |t|
    t.integer  "function_manager_id"
    t.integer  "organisation_id"
    t.string   "name"
    t.integer  "existing_proposed",                    :default => 0
    t.integer  "purpose_overall_5",                    :default => 0
    t.integer  "purpose_overall_6",                    :default => 0
    t.integer  "purpose_overall_7",                    :default => 0
    t.integer  "purpose_overall_8",                    :default => 0
    t.integer  "purpose_overall_9",                    :default => 0
    t.integer  "purpose_gender_3",                     :default => 0
    t.integer  "purpose_race_3",                       :default => 0
    t.integer  "purpose_disability_3",                 :default => 0
    t.integer  "purpose_faith_3",                      :default => 0
    t.integer  "purpose_sexual_orientation_3",         :default => 0
    t.integer  "purpose_age_3",                        :default => 0
    t.integer  "purpose_gender_4",                     :default => 0
    t.integer  "purpose_race_4",                       :default => 0
    t.integer  "purpose_disability_4",                 :default => 0
    t.integer  "purpose_faith_4",                      :default => 0
    t.integer  "purpose_sexual_orientation_4",         :default => 0
    t.integer  "purpose_age_4",                        :default => 0
    t.integer  "approved",                             :default => 0
    t.string   "approver"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "updated_by"
    t.integer  "impact_overall_1",                     :default => 0
    t.integer  "impact_overall_2",                     :default => 0
    t.string   "impact_overall_3"
    t.integer  "impact_overall_4",                     :default => 0
    t.text     "impact_overall_5"
    t.integer  "impact_gender_1",                      :default => 0
    t.integer  "impact_gender_2",                      :default => 0
    t.string   "impact_gender_3"
    t.integer  "impact_gender_4",                      :default => 0
    t.text     "impact_gender_5"
    t.integer  "impact_race_1",                        :default => 0
    t.integer  "impact_race_2",                        :default => 0
    t.string   "impact_race_3"
    t.integer  "impact_race_4",                        :default => 0
    t.text     "impact_race_5"
    t.integer  "impact_disability_1",                  :default => 0
    t.integer  "impact_disability_2",                  :default => 0
    t.string   "impact_disability_3"
    t.integer  "impact_disability_4",                  :default => 0
    t.text     "impact_disability_5"
    t.integer  "impact_faith_1",                       :default => 0
    t.integer  "impact_faith_2",                       :default => 0
    t.string   "impact_faith_3"
    t.integer  "impact_faith_4",                       :default => 0
    t.text     "impact_faith_5"
    t.integer  "impact_sexual_orientation_1",          :default => 0
    t.integer  "impact_sexual_orientation_2",          :default => 0
    t.string   "impact_sexual_orientation_3"
    t.integer  "impact_sexual_orientation_4",          :default => 0
    t.text     "impact_sexual_orientation_5"
    t.integer  "impact_age_1",                         :default => 0
    t.integer  "impact_age_2",                         :default => 0
    t.string   "impact_age_3"
    t.integer  "impact_age_4",                         :default => 0
    t.text     "impact_age_5"
    t.integer  "impact_overall_6",                     :default => 0
    t.integer  "impact_overall_7",                     :default => 0
    t.integer  "impact_overall_8",                     :default => 0
    t.integer  "impact_overall_9",                     :default => 0
    t.text     "impact_overall_10"
    t.integer  "impact_gender_6",                      :default => 0
    t.integer  "impact_gender_7",                      :default => 0
    t.integer  "impact_gender_8",                      :default => 0
    t.integer  "impact_gender_9",                      :default => 0
    t.text     "impact_gender_10"
    t.integer  "impact_race_6",                        :default => 0
    t.integer  "impact_race_7",                        :default => 0
    t.integer  "impact_race_8",                        :default => 0
    t.integer  "impact_race_9",                        :default => 0
    t.text     "impact_race_10"
    t.integer  "impact_disability_6",                  :default => 0
    t.integer  "impact_disability_7",                  :default => 0
    t.integer  "impact_disability_8",                  :default => 0
    t.integer  "impact_disability_9",                  :default => 0
    t.text     "impact_disability_10"
    t.integer  "impact_faith_6",                       :default => 0
    t.integer  "impact_faith_7",                       :default => 0
    t.integer  "impact_faith_8",                       :default => 0
    t.integer  "impact_faith_9",                       :default => 0
    t.text     "impact_faith_10"
    t.integer  "impact_sexual_orientation_6",          :default => 0
    t.integer  "impact_sexual_orientation_7",          :default => 0
    t.integer  "impact_sexual_orientation_8",          :default => 0
    t.integer  "impact_sexual_orientation_9",          :default => 0
    t.text     "impact_sexual_orientation_10"
    t.integer  "impact_age_6",                         :default => 0
    t.integer  "impact_age_7",                         :default => 0
    t.integer  "impact_age_8",                         :default => 0
    t.integer  "impact_age_9",                         :default => 0
    t.text     "impact_age_10"
    t.integer  "consultation_gender_2",                :default => 0
    t.text     "consultation_gender_3"
    t.integer  "consultation_gender_4",                :default => 0
    t.integer  "consultation_gender_5",                :default => 0
    t.text     "consultation_gender_6"
    t.integer  "consultation_gender_7",                :default => 0
    t.integer  "consultation_race_1",                  :default => 0
    t.integer  "consultation_race_2",                  :default => 0
    t.text     "consultation_race_3"
    t.integer  "consultation_race_4",                  :default => 0
    t.integer  "consultation_race_5",                  :default => 0
    t.text     "consultation_race_6"
    t.integer  "consultation_race_7",                  :default => 0
    t.integer  "consultation_disability_1",            :default => 0
    t.integer  "consultation_disability_2",            :default => 0
    t.text     "consultation_disability_3"
    t.integer  "consultation_disability_4",            :default => 0
    t.integer  "consultation_disability_5",            :default => 0
    t.text     "consultation_disability_6"
    t.integer  "consultation_disability_7",            :default => 0
    t.integer  "consultation_faith_1",                 :default => 0
    t.integer  "consultation_faith_2",                 :default => 0
    t.text     "consultation_faith_3"
    t.integer  "consultation_faith_4",                 :default => 0
    t.integer  "consultation_faith_5",                 :default => 0
    t.text     "consultation_faith_6"
    t.integer  "consultation_faith_7",                 :default => 0
    t.integer  "consultation_sexual_orientation_1",    :default => 0
    t.integer  "consultation_sexual_orientation_2",    :default => 0
    t.text     "consultation_sexual_orientation_3"
    t.integer  "consultation_sexual_orientation_4",    :default => 0
    t.integer  "consultation_sexual_orientation_5",    :default => 0
    t.text     "consultation_sexual_orientation_6"
    t.integer  "consultation_sexual_orientation_7",    :default => 0
    t.integer  "consultation_age_1",                   :default => 0
    t.integer  "consultation_age_2",                   :default => 0
    t.text     "consultation_age_3"
    t.integer  "consultation_age_4",                   :default => 0
    t.integer  "consultation_age_5",                   :default => 0
    t.text     "consultation_age_6"
    t.integer  "consultation_age_7",                   :default => 0
    t.text     "purpose_overall_2"
    t.integer  "consultation_gender_1",                :default => 0
    t.integer  "additional_work_gender_1",             :default => 0
    t.text     "additional_work_gender_2"
    t.integer  "additional_work_gender_3",             :default => 0
    t.integer  "additional_work_gender_4",             :default => 0
    t.integer  "additional_work_gender_5",             :default => 0
    t.integer  "additional_work_gender_6",             :default => 0
    t.integer  "additional_work_race_1",               :default => 0
    t.text     "additional_work_race_2"
    t.integer  "additional_work_race_3",               :default => 0
    t.integer  "additional_work_race_4",               :default => 0
    t.integer  "additional_work_race_5",               :default => 0
    t.integer  "additional_work_race_6",               :default => 0
    t.integer  "additional_work_race_7",               :default => 0
    t.integer  "additional_work_disability_1",         :default => 0
    t.text     "additional_work_disability_2"
    t.integer  "additional_work_disability_3",         :default => 0
    t.integer  "additional_work_disability_4",         :default => 0
    t.integer  "additional_work_disability_5",         :default => 0
    t.integer  "additional_work_disability_6",         :default => 0
    t.integer  "additional_work_disability_7",         :default => 0
    t.integer  "additional_work_disability_8",         :default => 0
    t.integer  "additional_work_sexual_orientation_1", :default => 0
    t.text     "additional_work_sexual_orientation_2"
    t.integer  "additional_work_sexual_orientation_3", :default => 0
    t.integer  "additional_work_sexual_orientation_4", :default => 0
    t.integer  "additional_work_sexual_orientation_5", :default => 0
    t.integer  "additional_work_sexual_orientation_6", :default => 0
    t.integer  "additional_work_sexual_orientation_7", :default => 0
    t.integer  "additional_work_age_1",                :default => 0
    t.text     "additional_work_age_2"
    t.integer  "additional_work_age_3",                :default => 0
    t.integer  "additional_work_age_4",                :default => 0
    t.integer  "additional_work_age_5",                :default => 0
    t.integer  "additional_work_age_6",                :default => 0
    t.integer  "additional_work_age_7",                :default => 0
    t.integer  "additional_work_faith_1",              :default => 0
    t.text     "additional_work_faith_2"
    t.integer  "additional_work_faith_3",              :default => 0
    t.integer  "additional_work_faith_4",              :default => 0
    t.integer  "additional_work_faith_5",              :default => 0
    t.integer  "additional_work_faith_6",              :default => 0
    t.integer  "additional_work_faith_7",              :default => 0
    t.integer  "additional_work_disability_9",         :default => 0
    t.integer  "additional_work_disability_10",        :default => 0
    t.integer  "function_policy",                      :default => 0
    t.integer  "directorate_id"
  end

  create_table "help_texts", :force => true do |t|
    t.string   "question_name",     :limit => 40
    t.text     "existing_function"
    t.text     "existing_policy"
    t.text     "proposed_function"
    t.text     "proposed_policy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "help_texts", ["question_name"], :name => "index_help_texts_on_question_name"

  create_table "issues", :force => true do |t|
    t.integer "activity_id"
    t.text    "description"
    t.text    "actions"
    t.text    "resources"
    t.string  "strand"
    t.text    "section"
    t.text    "recommendations"
    t.text    "monitoring"
    t.text    "outcomes"
    t.integer "parent_issue_id"
    t.date    "timescales"
    t.integer "lead_officer_id"
    t.date    "completing"
  end

  add_index "issues", ["activity_id"], :name => "index_issues_on_activity_id"

  create_table "logs", :force => true do |t|
    t.string   "type"
    t.string   "message"
    t.datetime "created_at"
    t.integer  "activity_id"
    t.integer  "user_id"
  end

  create_table "look_ups", :force => true do |t|
    t.integer "look_up_type"
    t.string  "name"
    t.integer "value"
    t.integer "weight"
    t.string  "description"
    t.integer "position"
  end

  create_table "notes", :force => true do |t|
    t.integer  "question_id"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_strategy_id"
  end

  add_index "notes", ["activity_strategy_id"], :name => "index_notes_on_activity_strategy_id"
  add_index "notes", ["question_id"], :name => "index_notes_on_question_id"

  create_table "organisation_terminologies", :force => true do |t|
    t.integer  "organisation_id"
    t.integer  "terminology_id"
    t.string   "value",           :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organisation_terminologies", ["organisation_id"], :name => "index_organisation_terminologies_on_organisation_id"
  add_index "organisation_terminologies", ["terminology_id"], :name => "index_organisation_terminologies_on_terminology_id"

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "strategy_text_selection", :default => 0
    t.string   "ces_link"
    t.string   "ces_term",                :default => "Corporate Equality Scheme"
    t.string   "subdomain",               :default => "www"
    t.boolean  "trial",                   :default => false,                       :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "name"
    t.integer  "activity_project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["organisation_id"], :name => "index_projects_on_organisation_id"

  create_table "questions", :force => true do |t|
    t.integer  "activity_id"
    t.string   "name"
    t.boolean  "completed",     :default => false
    t.boolean  "needed",        :default => false
    t.text     "raw_answer"
    t.text     "choices"
    t.string   "input_type"
    t.string   "section"
    t.string   "strand"
    t.integer  "dependency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_label"
    t.text     "raw_help_text"
  end

  add_index "questions", ["activity_id", "name", "needed", "completed"], :name => "index_questions_on_activity_id_and_name_and_needed_and_completed"
  add_index "questions", ["activity_id", "name"], :name => "activity_and_question_name", :unique => true
  add_index "questions", ["activity_id"], :name => "index_questions_on_activity_id"

  create_table "service_areas", :force => true do |t|
    t.integer "directorate_id"
    t.integer "approver_id"
    t.string  "name"
    t.boolean "retired",        :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "strategies", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.boolean  "retired",     :default => false
  end

  create_table "task_group_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terminologies", :force => true do |t|
    t.string   "term",       :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.boolean  "retired",                             :default => false
    t.boolean  "locked"
    t.boolean  "creator",                             :default => false
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "trained",                             :default => true
    t.string   "reset_password_token"
    t.boolean  "corporate_cop"
    t.datetime "password_changed_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
