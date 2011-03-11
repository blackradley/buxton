joe = User.create(:email => "joe@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass")
heather = User.create(:email => "heather@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass")
shaun = User.create(:email => "shaun@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass")
creator = User.create(:email => "creator@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass", :creator => true)
admin = Administrator.create(:email => "admin@27stars.co.uk", :password => "testpass", :password_confirmation => "testpass")


organisation = Organisation.create(:name => "Seed Organisation", :ces_term => "Corporate Equality Scheme", :strategy_text_selection => 0, :subdomain => "www")
["strategy", "corporate equality scheme", "directorate", "project"].each do |term|
  t = Terminology.create(:term => term)
  organisation.organisation_terminologies.create(:terminology => t, :value => t)
end
directorate = Directorate.create(:name => "Seed Directorate", :organisation => organisation)
joes_activity = Activity.create(:name => "Shauns Activity", :completer => joe, :approver => heather, :directorate => directorate)
shauns_activity = Activity.create(:name => "Joes Activity", :completer => shaun, :approver => heather, :directorate => directorate)
