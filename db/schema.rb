# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 101) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.integer  "existing_proposed",                        :limit => 11
    t.integer  "purpose_overall_5",                        :limit => 11
    t.integer  "purpose_overall_6",                        :limit => 11
    t.integer  "purpose_overall_7",                        :limit => 11
    t.integer  "purpose_overall_8",                        :limit => 11
    t.integer  "purpose_overall_9",                        :limit => 11
    t.integer  "purpose_gender_3",                         :limit => 11
    t.integer  "purpose_race_3",                           :limit => 11
    t.integer  "purpose_disability_3",                     :limit => 11
    t.integer  "purpose_faith_3",                          :limit => 11
    t.integer  "purpose_sexual_orientation_3",             :limit => 11
    t.integer  "purpose_age_3",                            :limit => 11
    t.integer  "purpose_gender_4",                         :limit => 11
    t.integer  "purpose_race_4",                           :limit => 11
    t.integer  "purpose_disability_4",                     :limit => 11
    t.integer  "purpose_faith_4",                          :limit => 11
    t.integer  "purpose_sexual_orientation_4",             :limit => 11
    t.integer  "purpose_age_4",                            :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "updated_by"
    t.integer  "impact_gender_1",                          :limit => 11
    t.integer  "impact_gender_2",                          :limit => 11
    t.string   "impact_gender_3"
    t.integer  "impact_gender_4",                          :limit => 11
    t.text     "impact_gender_5"
    t.integer  "impact_race_1",                            :limit => 11
    t.integer  "impact_race_2",                            :limit => 11
    t.string   "impact_race_3"
    t.integer  "impact_race_4",                            :limit => 11
    t.text     "impact_race_5"
    t.integer  "impact_disability_1",                      :limit => 11
    t.integer  "impact_disability_2",                      :limit => 11
    t.string   "impact_disability_3"
    t.integer  "impact_disability_4",                      :limit => 11
    t.text     "impact_disability_5"
    t.integer  "impact_faith_1",                           :limit => 11
    t.integer  "impact_faith_2",                           :limit => 11
    t.string   "impact_faith_3"
    t.integer  "impact_faith_4",                           :limit => 11
    t.text     "impact_faith_5"
    t.integer  "impact_sexual_orientation_1",              :limit => 11
    t.integer  "impact_sexual_orientation_2",              :limit => 11
    t.string   "impact_sexual_orientation_3"
    t.integer  "impact_sexual_orientation_4",              :limit => 11
    t.text     "impact_sexual_orientation_5"
    t.integer  "impact_age_1",                             :limit => 11
    t.integer  "impact_age_2",                             :limit => 11
    t.string   "impact_age_3"
    t.integer  "impact_age_4",                             :limit => 11
    t.text     "impact_age_5"
    t.integer  "impact_gender_6",                          :limit => 11
    t.text     "impact_gender_7"
    t.integer  "impact_gender_8",                          :limit => 11
    t.integer  "impact_gender_9",                          :limit => 11
    t.integer  "impact_race_6",                            :limit => 11
    t.text     "impact_race_7"
    t.integer  "impact_race_8",                            :limit => 11
    t.integer  "impact_race_9",                            :limit => 11
    t.integer  "impact_disability_6",                      :limit => 11
    t.text     "impact_disability_7"
    t.integer  "impact_disability_8",                      :limit => 11
    t.integer  "impact_disability_9",                      :limit => 11
    t.integer  "impact_faith_6",                           :limit => 11
    t.text     "impact_faith_7"
    t.integer  "impact_faith_8",                           :limit => 11
    t.integer  "impact_faith_9",                           :limit => 11
    t.integer  "impact_sexual_orientation_6",              :limit => 11
    t.text     "impact_sexual_orientation_7"
    t.integer  "impact_sexual_orientation_8",              :limit => 11
    t.integer  "impact_sexual_orientation_9",              :limit => 11
    t.integer  "impact_age_6",                             :limit => 11
    t.text     "impact_age_7"
    t.integer  "impact_age_8",                             :limit => 11
    t.integer  "impact_age_9",                             :limit => 11
    t.integer  "consultation_gender_2",                    :limit => 11
    t.text     "consultation_gender_3"
    t.integer  "consultation_gender_4",                    :limit => 11
    t.integer  "consultation_gender_5",                    :limit => 11
    t.text     "consultation_gender_6"
    t.integer  "consultation_gender_7",                    :limit => 11
    t.integer  "consultation_race_1",                      :limit => 11
    t.integer  "consultation_race_2",                      :limit => 11
    t.text     "consultation_race_3"
    t.integer  "consultation_race_4",                      :limit => 11
    t.integer  "consultation_race_5",                      :limit => 11
    t.text     "consultation_race_6"
    t.integer  "consultation_race_7",                      :limit => 11
    t.integer  "consultation_disability_1",                :limit => 11
    t.integer  "consultation_disability_2",                :limit => 11
    t.text     "consultation_disability_3"
    t.integer  "consultation_disability_4",                :limit => 11
    t.integer  "consultation_disability_5",                :limit => 11
    t.text     "consultation_disability_6"
    t.integer  "consultation_disability_7",                :limit => 11
    t.integer  "consultation_faith_1",                     :limit => 11
    t.integer  "consultation_faith_2",                     :limit => 11
    t.text     "consultation_faith_3"
    t.integer  "consultation_faith_4",                     :limit => 11
    t.integer  "consultation_faith_5",                     :limit => 11
    t.text     "consultation_faith_6"
    t.integer  "consultation_faith_7",                     :limit => 11
    t.integer  "consultation_sexual_orientation_1",        :limit => 11
    t.integer  "consultation_sexual_orientation_2",        :limit => 11
    t.text     "consultation_sexual_orientation_3"
    t.integer  "consultation_sexual_orientation_4",        :limit => 11
    t.integer  "consultation_sexual_orientation_5",        :limit => 11
    t.text     "consultation_sexual_orientation_6"
    t.integer  "consultation_sexual_orientation_7",        :limit => 11
    t.integer  "consultation_age_1",                       :limit => 11
    t.integer  "consultation_age_2",                       :limit => 11
    t.text     "consultation_age_3"
    t.integer  "consultation_age_4",                       :limit => 11
    t.integer  "consultation_age_5",                       :limit => 11
    t.text     "consultation_age_6"
    t.integer  "consultation_age_7",                       :limit => 11
    t.text     "purpose_overall_2"
    t.integer  "consultation_gender_1",                    :limit => 11
    t.integer  "additional_work_gender_1",                 :limit => 11
    t.text     "additional_work_gender_2"
    t.integer  "additional_work_gender_3",                 :limit => 11
    t.integer  "additional_work_gender_4",                 :limit => 11
    t.integer  "additional_work_race_1",                   :limit => 11
    t.text     "additional_work_race_2"
    t.integer  "additional_work_race_3",                   :limit => 11
    t.integer  "additional_work_race_4",                   :limit => 11
    t.integer  "additional_work_race_6",                   :limit => 11
    t.integer  "additional_work_disability_1",             :limit => 11
    t.text     "additional_work_disability_2"
    t.integer  "additional_work_disability_3",             :limit => 11
    t.integer  "additional_work_disability_4",             :limit => 11
    t.integer  "additional_work_disability_6",             :limit => 11
    t.integer  "additional_work_disability_7",             :limit => 11
    t.integer  "additional_work_sexual_orientation_1",     :limit => 11
    t.text     "additional_work_sexual_orientation_2"
    t.integer  "additional_work_sexual_orientation_3",     :limit => 11
    t.integer  "additional_work_sexual_orientation_4",     :limit => 11
    t.integer  "additional_work_sexual_orientation_6",     :limit => 11
    t.integer  "additional_work_age_1",                    :limit => 11
    t.text     "additional_work_age_2"
    t.integer  "additional_work_age_3",                    :limit => 11
    t.integer  "additional_work_age_4",                    :limit => 11
    t.integer  "additional_work_age_6",                    :limit => 11
    t.integer  "additional_work_faith_1",                  :limit => 11
    t.text     "additional_work_faith_2"
    t.integer  "additional_work_faith_3",                  :limit => 11
    t.integer  "additional_work_faith_4",                  :limit => 11
    t.integer  "additional_work_faith_6",                  :limit => 11
    t.integer  "additional_work_disability_8",             :limit => 11
    t.integer  "additional_work_disability_9",             :limit => 11
    t.integer  "function_policy",                          :limit => 11, :default => 0
    t.integer  "directorate_id",                           :limit => 11
    t.datetime "approved_on"
    t.integer  "percentage_importance",                    :limit => 11
    t.boolean  "purpose_completed",                                      :default => false
    t.boolean  "impact_completed",                                       :default => false
    t.boolean  "consultation_completed",                                 :default => false
    t.boolean  "additional_work_completed",                              :default => false
    t.boolean  "action_planning_completed",                              :default => false
    t.boolean  "use_purpose_completed",                                  :default => true
    t.integer  "gender_percentage_importance",             :limit => 11, :default => 0
    t.integer  "race_percentage_importance",               :limit => 11, :default => 0
    t.integer  "disability_percentage_importance",         :limit => 11, :default => 0
    t.integer  "sexual_orientation_percentage_importance", :limit => 11, :default => 0
    t.integer  "faith_percentage_importance",              :limit => 11, :default => 0
    t.integer  "age_percentage_importance",                :limit => 11, :default => 0
    t.integer  "ces_question",                             :limit => 11
    t.integer  "purpose_overall_11",                       :limit => 11, :default => 0
    t.integer  "purpose_overall_12",                       :limit => 11, :default => 0
    t.boolean  "gender_relevant"
    t.boolean  "sexual_orientation_relevant"
    t.boolean  "age_relevant"
    t.boolean  "faith_relevant"
    t.boolean  "disability_relevant"
    t.boolean  "race_relevant"
    t.string   "review_on"
    t.integer  "activity_project_id",                      :limit => 11
    t.string   "approved",                                               :default => "not submitted"
  end

  create_table "activities_projects", :id => false, :force => true do |t|
    t.integer "activity_id", :limit => 11
    t.integer "project_id",  :limit => 11
  end

  create_table "activity_strategies", :force => true do |t|
    t.integer "activity_id",       :limit => 11
    t.integer "strategy_id",       :limit => 11
    t.integer "strategy_response", :limit => 11
  end

  create_table "comments", :force => true do |t|
    t.integer  "question_id",          :limit => 11
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_strategy_id", :limit => 11
  end

  create_table "directorates", :force => true do |t|
    t.integer  "organisation_id", :limit => 11
    t.string   "name"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "help_texts", :force => true do |t|
    t.text     "question_name"
    t.text     "existing_function"
    t.text     "existing_policy"
    t.text     "proposed_function"
    t.text     "proposed_policy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", :force => true do |t|
    t.integer "activity_id",  :limit => 11
    t.text    "description"
    t.text    "actions"
    t.integer "timescales",   :limit => 11, :default => 0
    t.text    "resources"
    t.text    "lead_officer"
    t.string  "strand"
    t.text    "section"
  end

  create_table "logs", :force => true do |t|
    t.string   "type"
    t.string   "message"
    t.datetime "created_at"
  end

  create_table "look_ups", :force => true do |t|
    t.integer "look_up_type", :limit => 11
    t.string  "name"
    t.integer "value",        :limit => 11
    t.integer "weight",       :limit => 11
    t.string  "description"
    t.integer "position",     :limit => 11
  end

  create_table "notes", :force => true do |t|
    t.integer  "question_id",          :limit => 11
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_strategy_id", :limit => 11
  end

  create_table "organisation_terminologies", :force => true do |t|
    t.integer  "organisation_id", :limit => 11
    t.integer  "terminology_id",  :limit => 11
    t.string   "value",                         :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "style"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "strategy_text_selection", :limit => 11, :default => 0
    t.string   "ces_link"
    t.string   "ces_term",                              :default => "Corporate Equality Scheme"
  end

  create_table "projects", :force => true do |t|
    t.integer  "organisation_id",     :limit => 11
    t.string   "name"
    t.integer  "activity_project_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer "activity_id", :limit => 11
    t.string  "name"
    t.boolean "completed",                 :default => false
    t.boolean "needed",                    :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "strategies", :force => true do |t|
    t.integer  "organisation_id", :limit => 11
    t.string   "name"
    t.string   "description"
    t.integer  "position",        :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "type"
    t.integer  "directorate_id",  :limit => 11
    t.integer  "project_id",      :limit => 11
  end

  create_table "terminologies", :force => true do |t|
    t.string   "term",       :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "type"
    t.string   "passkey"
    t.string   "email"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.datetime "reminded_on"
    t.integer  "activity_id",     :limit => 11
    t.integer  "organisation_id", :limit => 11
    t.integer  "directorate_id",  :limit => 11
    t.integer  "project_id",      :limit => 11
  end

  add_index "users", ["passkey"], :name => "index_users_on_passkey"
  add_index "users", ["email"], :name => "index_users_on_email"

end
