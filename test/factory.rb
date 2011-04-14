Factory.define :activity do |activity|
  activity.sequence(:name){|i| "Activity #{i}"}
  activity.association :completer
  activity.association :approver
  activity.association :service_area
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

Factory.define :directorate do |dir|
  dir.sequence(:name){|i| "Directorate #{i}"}
  dir.sequence(:abbreviation){|i| "DR#{i}"}
  dir.association :creator
end