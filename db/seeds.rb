joe = User.create(:email => "joe@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass", :trained => true)
heather = User.create(:email => "heather@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass", :trained => true)
shaun = User.create(:email => "shaun@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass", :trained => true)
creator = User.create(:email => "creator@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass", :creator => true, :trained => true)
admin = Administrator.create(:email => "admin@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass")
[joe, heather, shaun, creator, admin].each do |u|
  u.update_attributes!(:password => "testpass", :password_confirmation => "testpass")
end
strategy = Strategy.create(:name => "Managing expectations", :description => "A measure of how one might measure expectations for this council")
directorate = Directorate.create!(:name => "Seed Directorate", :creator => joe, :cop => joe, :abbreviation => "SEED")
directorate.service_areas.create!(:name => "Sample Service Area", :approver => joe)

25.times do |n|
  joes_activity = Activity.create!(:name => "Shauns Activity #{n}", :completer => joe, :approver => heather, :service_area => directorate.service_areas.first)
  shauns_activity = Activity.create!(:name => "Joes Activity #{n}", :completer => shaun, :approver => heather, :service_area => directorate.service_areas.first)
end