Factory.define :activity do |activity|
  activity.sequence(:name){|i| "Activity #{i}"}
  activity.association :completer
  activity.association :approver
  activity.association :qc_officer
  activity.association :service_area
  activity.start_date Date.today
  activity.end_date Date.today
  activity.review_on Date.today
end

Factory.define :service_area do |sa|
  sa.sequence(:name){|i| "Service Area #{i}"}
  sa.association :approver
  sa.association :directorate
end

Factory.define :question do |question|
  question.section "impact"
  question.strand  "gender"
  question.sequence(:name){|i| "impact_gender_#{i}"}
  question.association :activity
  question.needed true
  question.completed false
end

Factory.define :issue do |i|
  i.description "Issue description"
  i.association :activity
end

Factory.define :user do |u|
  u.sequence(:email) {|n| "test#{n}@example.com"}
  u.password "password"
  u.password_confirmation "password"
end

Factory.define :completer, :parent => :user do |am|
end

Factory.define :approver, :parent => :user do |am|
end

Factory.define :creator, :parent => :user do |c|
  c.creator true
end

Factory.define :corporate_cop, :parent => :user do |c|
  c.corporate_cop true
end

Factory.define :cop, :parent => :user do |c|
end

Factory.define :qc_officer, :parent => :user do |qc|
end



Factory.define :administrator do |a|
  a.sequence(:email) {|n| "admin#{n}@example.com"}
  a.password "password"
  a.password_confirmation "password"
end

Factory.define :strategy do |s|
  s.sequence(:name){|i| "Strategy #{i}"}
end

Factory.define :directorate do |dir|
  dir.sequence(:name){|i| "Directorate #{i}"}
  dir.sequence(:abbreviation){|i| "DR#{i}"}
  dir.association :creator
  dir.association :cop
end