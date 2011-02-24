Factory.define :activity do |activity|
  activity.sequence(:name){|i| "Activity #{i}"}
  activity.association :activity_manager
  activity.association :activity_approver
  activity.association :directorate
end

Factory.define :issue do |i|
  i.description "Issue description"
  i.actions "Action to be taken on issuing this issue"
  i.resources "Stuff available when doing this issue"
  i.lead_officer "Issue Officer"
  i.timescales "12-18 months"
end

Factory.define :user do |u|
  u.sequence(:email){|i| "user#{i}@27stars.co.uk"}
  u.passkey{|u| User.generate_passkey(u)}
end

Factory.define :activity_manager, :parent => :user, :class => ActivityManager do |am|
  am.type "ActivityManager"
end

Factory.define :activity_approver, :parent => :user, :class => ActivityApprover do |am|
  am.type "ActivityApprover"
end

Factory.define :organisation_manager, :parent => :user, :class => OrganisationManager do |om|
  om.type "OrganisationManager"
  om.association :organisation
end

Factory.define :directorate_manager, :parent => :user, :class => DirectorateManager do |dm|
  dm.type "DirectorateManager"
end

Factory.define :directorate do |dir|
  dir.sequence(:name){|i| "Directorate #{i}"}
  dir.association :organisation
  dir.association :directorate_manager
end

Factory.define :organisation do |org|
  org.sequence(:name){|o| "Organisation #{o}"}
  org.ces_term "Corporate Equality Scheme"
  org.strategy_text_selection 0
  org.subdomain "www"
  
  org.after_build do |o|
     o.organisation_managers = (1..5).map{Factory.build(:organisation_manager, :organisation => o)}
  end
end